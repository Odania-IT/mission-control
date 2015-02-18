class BackgroundSchedule
	include Mongoid::Document
	include Mongoid::Timestamps

	STRATEGIES = [:mysql]

	field :name, type: String
	field :cron_type, type: String
	field :cron_times, type: String
	field :strategy, type: Symbol

	belongs_to :image
	belongs_to :server

	validates_uniqueness_of :name
	validates_length_of :name, minimum: 2
	validates_presence_of :image, :server
	validate :validate_strategy

	def validate_strategy
		unless STRATEGIES.include? self.strategy
			errors.add(:strategy, 'invalid strategy')
		end
	end

	after_save do
		DockerChange.update_schedules(self.server)

		true
	end

	after_destroy do
		DockerChange.update_schedules(self.server)

		true
	end
end
