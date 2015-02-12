require 'erubis'

class TemplateGenerator
	attr_accessor :hostname

	def initialize
		self.hostname = Docker.info['Name']
	end

	def generate(server)
		$LOGGER.debug "Creating config for: #{server.proxy_type} Apps: #{server.applications.inspect}"
		$SERVER.reload

		config_generator = NginxConfig.new
		if server.proxy_type == :haproxy
			config_generator = HaproxyConfig.new
		end

		current_config = ''
		begin
			current_config = config_generator.get_current_config
		rescue
			$LOGGER.warn 'No proxy configuration found!'
		end
		new_config = config_generator.generate_template(server.applications)

		if not current_config.eql? new_config
			config_generator.reload_proxy
		else
			$LOGGER.info 'Proxy Configuration did not change'
		end
	end
end
