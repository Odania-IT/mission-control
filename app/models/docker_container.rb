class DockerContainer
	include Mongoid::Document
	include Mongoid::Timestamps

	belongs_to :server
	belongs_to :container

	field :name, type: String
	field :docker_id, type: String

	validates_presence_of :server_id, :container_id, :name, :docker_id
end
