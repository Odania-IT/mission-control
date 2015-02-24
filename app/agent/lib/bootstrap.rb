require_relative './agent_helper'
require 'mongoid'

def check_capped_collection
	# Check if the capped collection exists
	moped_session = Mongoid::Sessions.default
	unless moped_session.collection_names.include? 'docker_changes'
		moped_session.command(create: 'docker_changes', capped: true, size: 10000000, max: 1000)
	end
end

# Make sure we are not running rails but only the agent
if AgentHelper.module_exists?('Rails')
	check_capped_collection
else
	# Load dependencies
	require 'rubygems'
	require 'bundler/setup'
	require 'docker'
	require 'logger'
	require 'json'
	require 'whenever'

	require_relative '../../models/server'
	require_relative '../../models/application'
	require_relative '../../models/application_log'
	require_relative '../../models/background_schedule'
	require_relative '../../models/backup_server'
	require_relative '../../models/image'
	require_relative '../../models/container'
	require_relative '../../models/server_container'
	require_relative '../../models/docker_change'
	require_relative '../../models/repository'

	require_relative './template_generator'
	require_relative './haproxy_config'
	require_relative './nginx_config'
	require_relative './docker_event_handler'
	require_relative './whenever_schedule_generator'

	$ROOT = File.realpath(File.dirname(__FILE__)+'/..')
	# Log to stdout so that we have it in the docker logs
	$LOGGER = Logger.new(STDOUT)
	$SERVER_NAME = Docker.info['Name']

	# Setup mongoid
	ENV['MONGOID_ENV'] = 'development' if ENV['MONGOID_ENV'].nil?
	Mongoid.load!($ROOT+'/config/mongoid.yml')

	$LOGGER.info "Starting #{$SCRIPT_TYPE} on #{Docker.info['Name']}"
	check_capped_collection

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
		$LOGGER.debug 'Server is not active'
		sleep 10
		exit
	end
end
