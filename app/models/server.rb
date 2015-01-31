class Server
	include Mongoid::Document
	include Mongoid::Timestamps

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

	validates_length_of :name, minimum: 2
	validates_length_of :hostname, minimum: 4
	validates_length_of :ip, minimum: 8, allow_nil: true
	validates_numericality_of :memory, :cpu

	has_and_belongs_to_many :applications
	has_many :containers
	embeds_many :server_containers

	before_create do
		self.active = false if self.active.nil?

		true
	end
end
