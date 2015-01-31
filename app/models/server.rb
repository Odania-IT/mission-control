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
	field :basic_auth, type: String
	field :volumes_path, type: String

	validates_length_of :name, minimum: 2
	validates_length_of :hostname, minimum: 4
	validates_length_of :ip, minimum: 8, allow_nil: true
	validates_numericality_of :memory, :cpu
	validates_length_of :volumes_path, minimum: 2, allow_nil: true
	validate :validate_basic_auth

	has_and_belongs_to_many :applications
	has_many :containers
	embeds_many :server_containers

	def validate_basic_auth
		if !self.basic_auth.nil? and (/\w+:\w+/ =~ self.basic_auth).nil?
			errors.add(:basic_auth, 'Please provide a correct basic auth "user_name:password"')
		end
	end

	before_create do
		self.active = false if self.active.nil?

		true
	end
end
