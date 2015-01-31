class Application
	include Mongoid::Document
	include Mongoid::Timestamps

	field :name, type: String
	field :domains, type: Array, default: []
	field :do_destroy, type: Mongoid::Boolean, default: false
	field :ports, type: Array, default: []
	field :basic_auth, type: String

	has_many :images
	has_and_belongs_to_many :servers
	has_many :containers

	validates_length_of :name, minimum: 2
	validate :validate_domains, :validate_ports, :validate_basic_auth

	def validate_domains
		self.domains.each do |domain|
			if domain.nil? or domain.blank?
				errors.add(:domains, "invalid domain: #{domain}")
			end
		end
	end

	def validate_basic_auth
		if !self.basic_auth.nil? and (/\w+:\w+/ =~ self.basic_auth).nil?
			errors.add(:basic_auth, 'Please provide a correct basic auth "user_name:password"')
		end
	end

	def validate_ports
		self.ports.each do |port|
			splitted = port.split(':')

			errors.add(:ports, "Image #{splitted[0]} does not exist in application!") if self.images.where(name: splitted[0]).count == 0
			errors.add(:ports, 'Invalid port! Use: IMAGE_NAME:IMAGE_PORT:PROXY_PORT') unless splitted.length == 3
			errors.add(:ports, "Invalid image port #{splitted[1]}") unless is_number? splitted[1]
			errors.add(:ports, "Invalid proxy port #{splitted[2]}") unless is_number? splitted[2]
		end
	end

	def is_number?(val)
		true if Float(val) rescue false
	end
end
