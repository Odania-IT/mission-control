require_relative '../agent/lib/agent_helper'

class Server
	include Mongoid::Document
	include Mongoid::Timestamps

	PROXY_TYPES = [:haproxy, :nginx]

	field :name, type: String
	field :hostname, type: String
	field :ip, type: String
	field :memory, type: Integer
	field :cpu, type: Integer
	field :os, type: String
	field :container_count, type: Integer, default: 0
	field :running_container_count, type: Integer, default: 0
	field :image_count, type: Integer, default: 0
	field :active, type: Mongoid::Boolean
	field :basic_auth, type: String
	field :volumes_path, type: String
	field :proxy_type, type: Symbol, default: :nginx

	validates_length_of :name, minimum: 2
	validates_length_of :hostname, minimum: 4
	validates_length_of :ip, minimum: 8, allow_nil: true
	validates_numericality_of :memory, :cpu
	validates_length_of :volumes_path, minimum: 2, allow_nil: true
	validates_uniqueness_of :hostname
	validate :validate_basic_auth, :validate_proxy_type

	has_and_belongs_to_many :applications
	has_many :containers
	embeds_many :server_containers

	def validate_basic_auth
		self.basic_auth = nil if self.basic_auth.nil? or self.basic_auth.blank?
		if !self.basic_auth.nil? and (/\w+:\w+/ =~ self.basic_auth).nil?
			errors.add(:basic_auth, 'Please provide a correct basic auth "user_name:password"')
		end
	end

	def validate_proxy_type
		unless PROXY_TYPES.include? self.proxy_type
			errors.add(:proxy_type, 'invalid proxy type')
		end
	end

	before_create do
		self.active = false if self.active.nil?

		true
	end

	before_save do
		self.volumes_path = File.absolute_path(self.volumes_path) unless self.volumes_path.nil?

		true
	end

	after_save do
		DockerChange.check_instances(self) if ::AgentHelper.module_exists?('Rails')

		true
	end
end
