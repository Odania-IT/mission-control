class ServerContainer
	include Mongoid::Document
	include Mongoid::Timestamps

	STATUSES = [:up, :down, :unknown]

	field :name, type: String
	field :docker_id, type: String
	field :image, type: String
	field :status, type: String
	field :ip, type: String

	belongs_to :container
	embedded_in :server

	validates_uniqueness_of :docker_id, :ip
	validate :validate_status

	def validate_status
		unless STATUSES.include? self.status.to_sym
			errors.add(:status, 'invalid status')
		end
	end

	def update_from_docker_container(docker_container)
		self.ip = docker_container.info['NetworkSettings']['IPAddress']
	end
end
