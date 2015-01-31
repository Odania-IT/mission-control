class ServerContainer
	include Mongoid::Document
	include Mongoid::Timestamps

	STATUSES = [:up, :down]

	field :name, type: String
	field :docker_id, type: String
	field :image, type: String
	field :status, type: String
	field :is_managed, type: Mongoid::Boolean, default: false
	field :ip, type: String

	belongs_to :container
	embedded_in :server

	validate :validate_status

	def validate_status
		unless STATUSES.include? self.status.to_sym
			errors.add(:status, 'invalid status')
		end
	end
end
