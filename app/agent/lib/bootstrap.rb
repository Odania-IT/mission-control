require_relative './agent_helper'

# Make sure we are not running rails but only the agent
unless AgentHelper.module_exists?('Rails')
	# Load dependencies
	require 'rubygems'
	require 'bundler/setup'
	require 'docker'
	require 'logger'
	require 'json'
	require 'mongoid'

	require_relative '../../models/server'
	require_relative '../../models/application'
	require_relative '../../models/image'
	require_relative '../../models/container'
	require_relative '../../models/server_container'
	require_relative '../../models/docker_change'

	require_relative './template_generator'
	require_relative './haproxy_config'
	require_relative './docker_event_handler'

	$ROOT = File.realpath(File.dirname(__FILE__)+'/..')
	# TODO change log directory
	$LOGGER = Logger.new('/tmp/agent.log', 0, 100 * 1024 * 1024)
	$SERVER_NAME = Docker.info['Name']

	# Setup mongoid
	ENV['MONGOID_ENV'] = 'development' if ENV['MONGOID_ENV'].nil?
	Mongoid.load!($ROOT+'/config/mongoid.yml')

	$LOGGER.info "Starting #{$SCRIPT_TYPE} on #{Docker.info['Name']}"

	# Load $SERVER
	$SERVER = Server.where(hostname: $SERVER_NAME).first
	running_container_count = Docker::Container.all.count
	if $SERVER.nil?
		$SERVER = Server.create!(name: $SERVER_NAME, hostname: $SERVER_NAME, memory: Docker.info['MemTotal'], cpu: Docker.info['NCPU'],
		 os: Docker.info['OperatingSystem'], container_count: Docker.info['Containers'], image_count: Docker.info['Images'], running_container_count: running_container_count)
	else
		$SERVER.memory = Docker.info['MemTotal']
		$SERVER.cpu = Docker.info['NCPU']
		$SERVER.container_count = Docker.info['Containers']
		$SERVER.image_count = Docker.info['Images']
		$SERVER.running_container_count = running_container_count
		$SERVER.save!
	end

	unless $SERVER.active
		puts 'Server is not active'
		exit
	end

	# Check if the capped collection exists
	moped_session = Mongoid::Sessions.default
	unless moped_session.collection_names.include? 'docker_changes'
		moped_session.command(create: 'docker_changes', capped: true, size: 10000000, max: 1000)
	end
end
