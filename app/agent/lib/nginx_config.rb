class NginxConfig
	attr_accessor :apps, :template

	def generate_template(appications)
		config_template = File.read($ROOT+'/templates/nginx_vhost.conf.erb')
		self.init(appications, config_template)
		new_config = self.render
		File.write('/etc/nginx/sites-enabled/default.conf', new_config)
		new_config
	end

	# Just write the configuration files
	def reload_proxy
		$LOGGER.info 'Reloading nginx'
		cmd = 'service nginx reload'
		system(cmd)
	end

	def get_current_config
		File.read('/etc/nginx/sites-enabled/default.conf')
	end

	def init(applications, template)
		@applications = applications
		@template = template
		@server = $SERVER
	end

	def render
		Erubis::Eruby.new(@template).result(binding)
	end
end
