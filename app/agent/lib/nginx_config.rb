class NginxConfig
	attr_accessor :apps, :template

	def generate_template(applications)
		config_template = File.read($ROOT+'/templates/nginx_vhost.conf.erb')
		self.init(applications, config_template)
		new_config = self.render
		File.write('/etc/nginx/sites-enabled/default.conf', new_config)

		generate_htaccess_files(applications)

		new_config
	end

	def generate_htaccess_files(applications)
		applications.each do |application|
			if application.basic_auth
				user, pass = application.basic_auth.split(':')

				file_name = "/etc/nginx/#{application.name.downcase.parameterize}.htpasswd"
				File.delete file_name if File.exists?(file_name)
				cmd = "htpasswd -c -db #{file_name} #{user} #{pass}"
				system(cmd)
			end
		end
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
