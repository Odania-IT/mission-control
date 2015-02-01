require 'erubis'

class TemplateGenerator
	attr_accessor :hostname

	def initialize
		self.hostname = Docker.info['Name']
	end

	def generate(server)
		$LOGGER.debug "Apps: #{server.applications.inspect}"

		current_config = ''
		begin
			current_config = File.read('/etc/haproxy/haproxy.cfg')
		rescue
			$LOGGER.warn 'No haproxy configuration found!'
		end
		new_config = self.generate_template(server.applications)

		if not current_config.eql? new_config
			self.reload_haproxy(new_config)
		else
			$LOGGER.info 'HAProxy Configuration did not change'
		end
	end

	def generate_template(appications)
		config_template = File.read($ROOT+'/templates/haproxy.cfg.erb')
		return HaproxyConfig.new(appications, config_template).render
	end

	# http://www.mgoff.in/2010/04/18/haproxy-reloading-your-config-with-minimal-service-impact/
	def reload_haproxy(new_config)
		$LOGGER.info 'Reloading haproxy'
		File.write('/etc/haproxy/haproxy.cfg', new_config)
		cmd = 'haproxy -db -f /etc/haproxy/haproxy.cfg -p /var/run/haproxy.pid -sf $(cat /var/run/haproxy.pid)'
		system(cmd)
	end
end
