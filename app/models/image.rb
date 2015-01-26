class Image
	include Mongoid::Document
	include Mongoid::Timestamps

	field :name, type: String
	field :image, type: String
	field :volumes, type: Array
	field :ports, type: Array
	field :image_type, type: Symbol
	field :links, type: Array
	field :environment, type: Array

	belongs_to :application

	validate :validate_image_type

	def validate_image_type
		unless [:db, :web].include? self.image_type
			errors.add(:image_type, 'invalid image type')
		end
	end
end
