class HaproxyConfig
	attr_accessor :apps, :template

	def initialize(applications, template)
		@applications = applications
		@template = template
		@server = $SERVER
	end

	def render
		Erubis::Eruby.new(@template).result(binding)
	end
end
