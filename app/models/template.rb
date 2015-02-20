class Template
	include Mongoid::Document
	include Mongoid::Timestamps

	field :name, type: String
	field :description, type: String
	field :image, type: Array, default: []
	field :volumes, type: Array, default: []
	field :ports, type: Array, default: []
	field :environment, type: Array, default: []
	field :scalable, type: Mongoid::Boolean, default: false

	validates_uniqueness_of :name
	validates_length_of :name, minimum: 2
	validates_length_of :image, minimum: 4
end
