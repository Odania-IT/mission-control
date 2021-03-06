class Container
	include Mongoid::Document
	include Mongoid::Timestamps

	STATUSES = [:down, :partially_up, :up, :stopped, :destroy]

	field :current_instances, type: Integer, default: 0
	field :wanted_instances, type: Integer, default: 0
	field :status, type: Symbol
	field :scalable, type: Mongoid::Boolean

	field :last_check, type: DateTime

	belongs_to :server
	belongs_to :application
	belongs_to :image

	validates_presence_of :server, :application
	validate :validate_status

	def validate_status
		unless STATUSES.include? self.status
			errors.add(:status, 'invalid status')
		end
	end
end
