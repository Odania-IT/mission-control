class HaproxyConfig
	attr_accessor :apps, :template

	def initialize(applications, template)
		@applications = applications
		@template = template
		@server = $SERVER

		get_all_ports
	end

	def get_all_ports
		@all_ports = {}
		@target_ports = {}
		@image_on_port = {}
		@applications.each do |application|
			application.ports.each do |port|
				splitted = port.split(':')

				@all_ports[splitted[1]] = [] if @all_ports[splitted[1]].nil?
				@all_ports[splitted[1]] << application

				@target_ports[splitted[1]] = {} if @target_ports[splitted[1]].nil?
				@target_ports[splitted[1]][application.id.to_s] = splitted[2]

				@image_on_port[splitted[1]] = {} if @image_on_port[splitted[1]].nil?
				@image_on_port[splitted[1]][application.id.to_s] = splitted[0]
			end
		end
	end

	def render
		Erubis::Eruby.new(@template).result(binding)
	end
end
