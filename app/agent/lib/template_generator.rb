require 'erubis'

class TemplateGenerator
	attr_accessor :hostname

	def initialize
		self.hostname = Docker.info['Name']
	end

	def generate(server)
		apps = []
		server.applications.each do |application|
			begin
				# Get all exposed containers
				# TODO

			rescue => e
				$LOGGER.error "Exception template_generator: #{e}"
			end
		end

		config_store.hgetall('apps').each do |redis_app|
			begin
				app = App.build(redis_app)
				app.populate_containers(hostname, config_store)

				apps << app
			rescue => e
				$LOGGER.error "Exception template_generator: #{e}"
			end
		end

		$LOGGER.debug "Apps: #{apps.inspect}"

		current_config = File.read('/etc/haproxy/haproxy.cfg')
		new_config = self.generate_template(apps)

		if not current_config.eql? new_config
			self.reload_haproxy(new_config)
		else
			$LOGGER.info 'HAProxy Configuration did not change'
		end
	end

	def generate_template(apps)
		config_template = File.read($ROOT+'/agent/templates/haproxy.cfg')
		return HaproxyConfig.new(apps, config_template).render
	end

	# http://www.mgoff.in/2010/04/18/haproxy-reloading-your-config-with-minimal-service-impact/
	def reload_haproxy(new_config)
		$LOGGER.info 'Reloading haproxy'
		File.write('/etc/haproxy/haproxy.cfg', new_config)
		cmd = 'haproxy -f /etc/haproxy/haproxy.cfg -p /var/run/haproxy.pid -sf $(cat /var/run/haproxy.pid)'
		system(cmd)
	end
end
