$SCRIPT_TYPE = 'Docker Starter'
require_relative './lib/bootstrap'

# Sort all containers
all_containers = {}
container_names = []
Docker::Container.all(:all => true).each do |docker_container|
	container_image = docker_container.info['Image']
	mongo_docker_container = DockerContainer.where(server: $SERVER, docker_id: docker_container.id).first
	container_image = mongo_docker_container.container.image.image unless mongo_docker_container.nil?

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
	puts '------------------ Yeah Hell ------------------'
	image = container.image
	container_images = all_containers[image.image]
	container_images = {up: [], down: []} if container_images.nil? # if none is running set empty

	running_instances = container_images[:up].count
	wanted_instances = container.wanted_instances
	start_instances = wanted_instances - running_instances

	# Check all up containers
	container_images[:up].each do |docker_container|
		if start_instances < 0
			puts "Stop delete #{docker_container.inspect}"
			docker_container.stop
			docker_container.delete
			start_instances += 1
			remove_all_from_array(container_names, docker_container.info['Names'])
		end
	end

	container_images[:down].each do |docker_container|
		puts "Delete #{docker_container.inspect}"
		docker_container.delete
		remove_all_from_array(container_names, docker_container.info['Names'])
	end

	while start_instances > 0
		puts 'Start new container'
		create_params = image.get_create_params(container_names)
		container_name = create_params['name']
		docker_container = Docker::Container.create(create_params)
		docker_container.start(image.get_start_params($SERVER))
		container_names << "/#{container_name}"

		mongo_docker_container = container.docker_containers.build
		mongo_docker_container.server = $SERVER
		mongo_docker_container.docker_id = docker_container.id
		mongo_docker_container.name = container_name
		mongo_docker_container.save!

		start_instances -= 1
	end

	container.last_check = Time.now
	container.save!
end

# Delete docker_container in mongo if it is not running
$SERVER.docker_containers.each do |mongo_docker_container|
	begin
		docker_container = Docker::Container.get(mongo_docker_container.docker_id)
	rescue Docker::Error::NotFoundError
		mongo_docker_container.destroy
	end
end
