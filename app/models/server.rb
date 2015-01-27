class Server
	include Mongoid::Document
	include Mongoid::Timestamps

	field :name, type: String
	field :hostname, type: String
	field :ip, type: String
	field :memory, type: Integer
	field :cpu, type: Integer
	field :active, type: Mongoid::Boolean

	validates_length_of :name, minimum: 2
	validates_length_of :hostname, minimum: 4
	validates_length_of :ip, minimum: 8
	validates_numericality_of :memory, :cpu

	has_and_belongs_to_many :applications
end
