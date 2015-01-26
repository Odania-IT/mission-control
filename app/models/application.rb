class Application
	include Mongoid::Document
	include Mongoid::Timestamps

	field :name, type: String
	field :domains, type: Array, default: []

	has_many :images
end
