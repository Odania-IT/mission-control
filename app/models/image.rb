class Image
	include Mongoid::Document
	include Mongoid::Timestamps

	IMAGE_TYPES = [:db, :web]

	field :name, type: String
	field :image_type, type: Symbol
	field :image, type: String
	field :volumes, type: Array, default: []
	field :ports, type: Array, default: []
	field :links, type: Array, default: []
	field :environment, type: Array, default: []
	field :scalable, type: Mongoid::Boolean

	belongs_to :application
	has_many :containers

	validates_length_of :name, minimum: 2
	validates_length_of :image, minimum: 4
	validate :validate_image_type

	def validate_image_type
		unless IMAGE_TYPES.include? self.image_type
			errors.add(:image_type, 'invalid image type')
		end
	end
end
