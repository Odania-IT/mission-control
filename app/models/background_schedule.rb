class BackgroundSchedule
	include Mongoid::Document
	include Mongoid::Timestamps

	CRON_TYPES = {
		backup: [:mysql, :volumes]
	}

	field :name, type: String
	field :cron_type, type: Symbol
	field :cron_times, type: String
	field :strategy, type: Symbol

	belongs_to :image
	belongs_to :server
	belongs_to :backup_server

	validates_uniqueness_of :name
	validates_length_of :name, minimum: 2
	validates_presence_of :image, :server
	validate :validate_strategy_and_cron_type

	def validate_strategy_and_cron_type
		unless CRON_TYPES.include? self.cron_type
			errors.add(:cron_type, 'invalid cron type')
		end
		if CRON_TYPES[self.cron_type].nil? or !CRON_TYPES[self.cron_type].include? self.strategy
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
