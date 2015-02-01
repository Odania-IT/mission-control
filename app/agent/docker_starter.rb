$SCRIPT_TYPE = 'Docker Starter'
require_relative './lib/bootstrap'

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

def remove_all_from_array(arr, to_remove)
	to_remove.each do |key|
		arr.delete(key)
	end
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
	end

	container.last_check = Time.now
	container.save!
end

# Delete docker_container in mongo if it is not running
$SERVER.server_containers.each do |server_container|
	begin
		Docker::Container.get(server_container.docker_id)
	rescue Docker::Error::NotFoundError
		server_container.destroy
	end
end
