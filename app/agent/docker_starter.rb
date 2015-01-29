# Load dependencies
require 'rubygems'
require 'bundler/setup'
require 'docker'
require 'logger'
require 'json'
require 'mongoid'

require_relative '../models/server'
require_relative '../models/application'
require_relative '../models/image'
require_relative '../models/container'
require_relative '../models/docker_container'

$ROOT = File.dirname(__FILE__)
# TODO change log directory
$LOGGER = Logger.new('/tmp/agent.log', 0, 100 * 1024 * 1024)
$SERVER_NAME = Docker.info['Name']

$LOGGER.info "Starting Docker Starter on #{Docker.info['Name']}"

# Setup mongoid
ENV['MONGOID_ENV'] = 'development' if ENV['MONGOID_ENV'].nil?
Mongoid.load!('config/mongoid.yml')

# Load server
server = Server.where(hostname: $SERVER_NAME).first
running_container_count = Docker::Container.all.count
if server.nil?
	server = Server.create!(name: $SERVER_NAME, hostname: $SERVER_NAME, memory: Docker.info['MemTotal'], cpu: Docker.info['NCPU'],
	 os: Docker.info['OperatingSystem'], container_count: Docker.info['Containers'], image_count: Docker.info['Images'], running_container_count: running_container_count)
else
	server.memory = Docker.info['MemTotal']
	server.cpu = Docker.info['NCPU']
	server.container_count = Docker.info['Containers']
	server.image_count = Docker.info['Images']
	server.running_container_count = running_container_count
	server.save!
end

unless server.active
	puts 'Server is not active'
	exit
end

# Sort all containers
all_containers = {}
container_names = []
Docker::Container.all(:all => true).each do |docker_container|
	container_image = docker_container.info['Image']
	mongo_docker_container = DockerContainer.where(server: server, docker_id: docker_container.id).first
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

server.containers.each do |container|
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
		if start_instances > 0
			puts "Start #{docker_container.inspect}"
			docker_container.start(image.get_start_params)
			start_instances -= 1
		else
			puts "Delete #{docker_container.inspect}"
			docker_container.delete
			remove_all_from_array(container_names, docker_container.info['Names'])
		end
	end

	while start_instances > 0
		puts 'Start new container'
		create_params = image.get_create_params(container_names)
		container_name = create_params['name']
		docker_container = Docker::Container.create(create_params)
		docker_container.start(image.get_start_params)
		container_names << "/#{container_name}"

		puts "NAME: #{container_name} | #{create_params.inspect}"

		mongo_docker_container = container.docker_containers.build
		mongo_docker_container.server = server
		mongo_docker_container.docker_id = docker_container.id
		mongo_docker_container.name = container_name
		mongo_docker_container.save!

		start_instances -= 1
	end

	container.last_check = Time.now
	container.save!
end

# Delete docker_container in mongo if it is not running
server.docker_containers.each do |mongo_docker_container|
	begin
		docker_container = Docker::Container.get(mongo_docker_container.docker_id)
	rescue Docker::Error::NotFoundError
		mongo_docker_container.destroy
	end
end
