class DockerContainer
	include Mongoid::Document
	include Mongoid::Timestamps

	belongs_to :server
	belongs_to :container

	field :name, type: String
	field :docker_id, type: String
end
