$SCRIPT_TYPE = 'Docker Starter'
require_relative './lib/bootstrap'

unless AgentHelper.module_exists?('Rails')
	def remove_all_from_array(arr, to_remove)
		to_remove.each do |key|
			arr.delete(key)
		end
	end

	# Make sure volumes path exists
	FileUtils.mkdir_p($SERVER.volumes_path) unless $SERVER.volumes_path.nil? or File.directory?($SERVER.volumes_path)

	def process
		$SERVER.reload

		# Sort all containers
		rerun_count = 0
		do_run = true

		while do_run
			container_names = []
			do_rerun = false

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
					end
				rescue Docker::Error::NotFoundError
					server_container.destroy
				end
			end

			# Collect all used names
			Docker::Container.all(:all => true).each do |docker_container|
				container_names = container_names + docker_container.info['Names']
			end

			$SERVER.containers.each do |container|
				image = container.image
				$LOGGER.debug "Checking container for image: #{container.image.name}"

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
								DockerChange.update_proxy($SERVER)
							end
						else
							$LOGGER.info "Deleting container #{docker_container.info['Names'].inspect}"
							docker_container.delete
							remove_all_from_array(container_names, docker_container.info['Names'])
						end
					rescue Docker::Error::NotFoundError
						server_container.destroy
					end
				end

				# Calculate how many instances to start
				wanted_instances = container.wanted_instances
				start_instances = wanted_instances - running_instances
				$LOGGER.debug "Container for #{container.image.name} running_instances: #{running_instances} wanted_instances: #{wanted_instances} start_instances: #{start_instances}"

				# Check if we need to stop containers
				while start_instances < 0
					$SERVER.server_containers.where(container: container).each do |server_container|
						docker_container = Docker::Container.get(server_container.docker_id)

						$LOGGER.info "Stopping container #{docker_container.info['Names'].inspect}"
						docker_container.stop
						docker_container.delete
						start_instances += 1
						remove_all_from_array(container_names, docker_container.info['Names'])
					end
				end

				while start_instances > 0
					$LOGGER.info "Starting new container #{container.image.name}"
					create_params = image.get_create_params(container_names)
					container_name = create_params['name'].clone

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
					else
						$LOGGER.debug "Can not start image #{image.name} due to unfulfilled dependencies"
						do_rerun = true
					end
				end

				if running_instances == container.wanted_instances
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
			$LOGGER.info 'Check to start containers'
			process
		else
			$LOGGER.debug "[Proxy Updater] Not processing: Correct Server? #{entry['server_id'].to_s.eql?($SERVER.id.to_s)} | check_instances: #{entry['check_instances']}"
		end
	end
end
