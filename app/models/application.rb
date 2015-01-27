class Application
	include Mongoid::Document
	include Mongoid::Timestamps

	field :name, type: String
	field :domains, type: Array, default: []

	has_many :images
	has_and_belongs_to_many :servers

	validates_length_of :name, minimum: 2
	validate :validate_domains

	def validate_domains
		self.domains.each do |domain|
			if domain.nil? or domain.blank?
				errors.add(:domains, "invalid domain: #{domain}")
			end
		end
	end
end
