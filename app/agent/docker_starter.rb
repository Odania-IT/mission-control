$SCRIPT_TYPE = 'Docker Starter'
require_relative './lib/bootstrap'

unless AgentHelper.module_exists?('Rails')
	def remove_all_from_array(arr, to_remove, name_to_remove)
		unless to_remove.nil?
			to_remove.each do |key|
				arr.delete(key)
			end
		end

		arr.delete(name_to_remove) unless name_to_remove.nil?
	end

	# Make sure volumes path exists
	FileUtils.mkdir_p($SERVER.volumes_path) unless $SERVER.volumes_path.nil? or File.directory?($SERVER.volumes_path)

	def process
		$SERVER.reload

		# Sort all containers
		rerun_count = 0
		do_run = true
		request_proxy_update = false

		# Authenticate to private repositories
		Repository.all.each do |repository|
			# TODO: Authenticate to private repo via api
			#Docker.authenticate!()
		end

		while do_run
			container_names = []
			do_rerun = false
			request_proxy_update = false

			# Delete docker_container in mongo if it is not running
			$SERVER.server_containers.each do |server_container|
				begin
					docker_container = Docker::Container.get(server_container.docker_id)

					if server_container.status == :destroy
						docker_container.stop
						docker_container.delete
						server_container.destroy

						container = server_container.container
						if container.server_containers.count == 0
							container.destroy
						end

						request_proxy_update = true
					end
				rescue Docker::Error::NotFoundError
					server_container.destroy
					request_proxy_update = true
				end
			end

			# Collect all used names
			Docker::Container.all(:all => true).each do |docker_container|
				container_names = container_names + docker_container.info['Names']
			end

			$SERVER.containers.each do |container|
				image = container.image
				image_name = image.nil? ? '-' : image.name
				$LOGGER.debug container.inspect
				$LOGGER.debug "Checking container for image: #{image_name}"

				# Check all server_containers in our db if they are still running
				running_instances = 0
				$SERVER.server_containers.where(container: container).each do |server_container|
					begin
						docker_container = Docker::Container.get(server_container.docker_id)
						state = docker_container.info['State']
						is_up = state['Running']

						if is_up
							running_instances += 1
							container_names = container_names + docker_container.info['Names'] unless docker_container.info['Names'].nil?
							container_names << docker_container.info['Name'] unless docker_container.info['Name'].nil?

							# Verify ip has not changed
							cur_ip = server_container.ip
							server_container.update_from_docker_container(docker_container)
							unless cur_ip.eql? server_container.ip
								server_container.save!
								request_proxy_update = true
							end
						else
							$LOGGER.info "Deleting container #{docker_container.info['Names'].inspect}"
							docker_container.delete
							remove_all_from_array(container_names, docker_container.info['Names'], docker_container.info['Name'])
							request_proxy_update = true
						end
					rescue Docker::Error::NotFoundError
						server_container.destroy
						request_proxy_update = true
					end
				end

				# Calculate how many instances to start
				wanted_instances = container.wanted_instances
				start_instances = wanted_instances - running_instances
				$LOGGER.debug "Container for #{image_name} running_instances: #{running_instances} wanted_instances: #{wanted_instances} start_instances: #{start_instances}"

				# Check if we need to stop containers
				while start_instances < 0
					$SERVER.server_containers.where(container: container).each do |server_container|
						docker_container = Docker::Container.get(server_container.docker_id)

						$LOGGER.info "Stopping container #{docker_container.info['Names'].inspect}"
						docker_container.stop
						docker_container.delete
						start_instances += 1
						remove_all_from_array(container_names, docker_container.info['Names'], docker_container.info['Name'])
						request_proxy_update = true
					end
				end

				# Start new docker container
				start_error_count = 0
				while start_instances > 0 and start_error_count < 20
					$LOGGER.info "Starting new container #{image_name}"
					create_params = image.get_create_params(container_names)
					container_name = create_params['name'].clone

					begin
						# Download image from server
						$LOGGER.debug "Loading image #{image.image}"
						Docker::Image.get(image.image)

						start_params = image.get_start_params($SERVER)
						if image.can_start
							docker_container = Docker::Container.create(create_params)
							docker_container.start(start_params)
							container_names << "/#{container_name}"

							# We need to fetch the container in order to retrieve additional data, e.g. ip
							docker_container = Docker::Container.get(docker_container.id)

							server_container = $SERVER.server_containers.where(docker_id: docker_container.id).first
							server_container = $SERVER.server_containers.build if server_container.nil?
							server_container.container = container
							server_container.docker_id = docker_container.id
							server_container.image = image.image
							server_container.name = container_name
							server_container.status = :up
							server_container.update_from_docker_container(docker_container)
							server_container.save!

							start_instances -= 1
							running_instances += 1
							request_proxy_update = true
							start_error_count = 0
						else
							$LOGGER.debug "Can not start image #{image.name} due to unfulfilled dependencies"
							do_rerun = true
						end
					rescue => e
						$LOGGER.error "Error occurred trying to start image #{image.image}"
						start_error_count += 1
					end
				end

				# Errors during startup
				if start_instances > 0 and start_error_count > 0
					ApplicationLog.error(:docker, "Failed to start new docker container for image #{image.image}", $SERVER, container)
				end

				if container.status == :destroy
					# Everything destroyed?
					container.destroy if start_instances == 0 and $SERVER.server_containers.where(container: container).count == 0
				elsif running_instances == container.wanted_instances
					container.status = :up
				elsif running_instances == 0
					container.status = :down
				elsif running_instances < container.wanted_instances
					container.status = :partially_up
				end

				container.current_instances = running_instances
				container.last_check = Time.now
				container.save!
			end

			if do_rerun
				rerun_count += 1
				do_run = false if rerun_count > 4
			else
				do_run = false
			end

			# Update proxy if necessary
			if request_proxy_update
				DockerChange.update_proxy($SERVER)
			end
		end # end do_run
	end

	# Run for the first time
	process

	# Get Last entry
	docker_change = DockerChange.order([:created_at, :desc]).first
	last_update = docker_change.nil? ? Time.now : docker_change.created_at

	# Start proxy process
	# check if one is already running. Can not run both!
	unless File.exists?('/etc/service/nginx') or File.exists?('/etc/service/haproxy')
		if $SERVER.proxy_type == :haproxy
			puts FileUtils.symlink '/etc/haproxy-runit', '/etc/service/haproxy'
		else
			puts FileUtils.symlink '/etc/nginx-runit', '/etc/service/nginx'
		end
	end

	# Additionally perform timed checks
	Thread.new do
		sleep 60
		process
	end

	moped_session = Mongoid::Sessions.default
	query = moped_session[:docker_changes].find(created_at: {'$gt' => last_update}).tailable
	cursor = query.cursor

	# Retrieve every line and update if necessary
	cursor.each do |entry|
		if entry['server_id'].to_s.eql?($SERVER.id.to_s) and entry['check_instances']
			$LOGGER.info '[Docker Starter] Check to start containers'
			process
		else
			$LOGGER.debug "[Docker Starter] Not processing: Correct Server? #{entry['server_id'].to_s.eql?($SERVER.id.to_s)} | check_instances: #{entry['check_instances']}"
		end
	end
end
