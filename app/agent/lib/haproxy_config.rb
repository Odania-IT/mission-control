class HaproxyConfig
	attr_accessor :apps, :template

	def generate_template(appications)
		config_template = File.read($ROOT+'/templates/haproxy.cfg.erb')
		self.init(appications, config_template)
		new_config = self.render
		File.write('/etc/haproxy/haproxy.cfg', new_config)
		new_config
	end

	# http://www.mgoff.in/2010/04/18/haproxy-reloading-your-config-with-minimal-service-impact/
	def reload_proxy
		$LOGGER.info 'Reloading haproxy'
		cmd = 'haproxy -db -f /etc/haproxy/haproxy.cfg -p /var/run/haproxy.pid -sf $(cat /var/run/haproxy.pid)'
		system(cmd)
	end

	def get_current_config
		File.read('/etc/haproxy/haproxy.cfg')
	end

	def init(applications, template)
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
