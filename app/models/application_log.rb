class ApplicationLog
	include Mongoid::Document
	include Mongoid::Timestamps

	LEVELS = [:debug, :info, :warn, :error]
	CATEGORIES = [:cron, :docker, :backup]

	field :level, type: Symbol
	field :category, type: Symbol
	field :message, type: String
	field :file, type: String

	belongs_to :server
	belongs_to :container

	index({ level: 1, category: 1 }, {})

	validates_presence_of :category, :message, :level
	validate :validate_level_and_category

	def validate_level_and_category
		unless LEVELS.include? self.level
			errors.add(:level, 'invalid level')
		end
		unless CATEGORIES.include? self.category
			errors.add(:category, 'invalid category')
		end
	end

	def self.debug(category, msg, server=nil, container=nil)
		log = ApplicationLog.new
		log.level = :debug
		log.category = category
		log.message = msg
		log.server = server
		log.container = container
		log.save!
	end

	def self.info(category, msg, server=nil, container=nil)
		log = ApplicationLog.new
		log.level = :info
		log.category = category
		log.message = msg
		log.server = server
		log.container = container
		log.save!
	end

	def self.warn(category, msg, server=nil, container=nil)
		log = ApplicationLog.new
		log.level = :warn
		log.category = category
		log.message = msg
		log.server = server
		log.container = container
		log.save!
	end

	def self.error(category, msg, server=nil, container=nil)
		log = ApplicationLog.new
		log.level = :error
		log.category = category
		log.message = msg
		log.server = server
		log.container = container
		log.save!
	end
end
