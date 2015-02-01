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
		# Sort all containers
		all_containers = {}
		container_names = []
		Docker::Container.all(:all => true).each do |docker_container|
			container_image = docker_container.info['Image']
			server_container = $SERVER.server_containers.where(docker_id: docker_container.id).first
			container_image = server_container.container.image.image if !server_container.nil? and !server_container.container.nil?

			all_containers[container_image] = {up: [], down: []} if all_containers[container_image].nil?

			is_up = docker_container.info['Status'].downcase.include? 'up'
			all_containers[container_image][:up] << docker_container if is_up
			all_containers[container_image][:down] << docker_container unless is_up
			container_names = container_names + docker_container.info['Names']
		end

		$SERVER.containers.each do |container|
			image = container.image
			container_images = all_containers[image.image]
			container_images = {up: [], down: []} if container_images.nil? # if none is running set empty

			running_instances = container_images[:up].count
			wanted_instances = container.wanted_instances
			start_instances = wanted_instances - running_instances

			# Check all up containers
			container_images[:up].each do |docker_container|
				if start_instances < 0
					$LOGGER.info "Stopping container #{docker_container.info['Names'].inspect}"
					docker_container.stop
					docker_container.delete
					start_instances += 1
					remove_all_from_array(container_names, docker_container.info['Names'])
				end
			end

			container_images[:down].each do |docker_container|
				$LOGGER.info "Deleting container #{docker_container.info['Names'].inspect}"
				server_container = $SERVER.server_containers.where(docker_id: docker_container.id).first
				if !server_container.nil? and server_container.is_managed
					docker_container.delete
					remove_all_from_array(container_names, docker_container.info['Names'])
				end
			end

			while start_instances > 0
				$LOGGER.info "Starting new container #{container.image.name}"
				create_params = image.get_create_params(container_names)
				container_name = create_params['name'].clone

				# Download image from server
				puts 'Loading image'
				Docker::Image.get(image.image)

				docker_container = Docker::Container.create(create_params)
				docker_container.start(image.get_start_params($SERVER))
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
				server_container.is_managed = true
				server_container.save!

				start_instances -= 1
				running_instances += 1
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
	end

	# Run for the first time
	process

	# Get Last entry
	docker_change = DockerChange.order([:created_at, :desc]).first
	last_update = docker_change.nil? ? Time.now : docker_change.created_at

	moped_session = Mongoid::Sessions.default
	query = moped_session[:docker_changes].find(created_at: {'$gt' => last_update}).tailable
	cursor = query.cursor

	# Retrieve every line and update if necessary
	cursor.each do |entry|
		if entry['server_id'].to_s.eql?($SERVER.id.to_s) and entry['check_instances']
			$LOGGER.info 'Check to start containers'
			process
		end
	end
end
