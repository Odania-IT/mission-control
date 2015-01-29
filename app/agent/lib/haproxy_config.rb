class HaproxyConfig
	attr_accessor :apps, :template

	def initialize(apps, template)
		@apps = apps
		@template = template
	end

	def render
		Erubis::Eruby.new(@template).result(binding)
	end
end
