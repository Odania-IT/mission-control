class Template
	include Mongoid::Document
	include Mongoid::Timestamps

	field :name, type: String
	field :description, type: String
	field :images, type: Array, default: []
	field :volumes, type: Array, default: []
	field :ports, type: Array, default: []
	field :environment, type: Array, default: []
	field :scalable, type: Mongoid::Boolean, default: false
	field :backup_strategy, type: Symbol

	validates_uniqueness_of :name
	validates_length_of :name, minimum: 2
	validate :validate_images

	def validate_images
		errors.add(:images, 'no image defined') if self.images.empty?

		self.images.each do |image|
			errors.add(:images, 'empty image not allowed') if image.blank?
		end
	end

	def validate_backup_strategy
		unless BackgroundSchedule::CRON_TYPES[:backup].include? self.backup_strategy
			errors.add(:backup_strategy, 'invalid backup strategy')
		end
	end
end
