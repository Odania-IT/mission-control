$SCRIPT_TYPE = 'Proxy Updater'
require_relative './lib/bootstrap'

template_generator = TemplateGenerator.new

# Generate first config
template_generator.generate($SERVER)

do_shutdown = false
last_update = Time.now.to_i

while not do_shutdown
	data = config_store.blpop("update_config:#{Docker.info['Name']}")
	update_time = data[1].to_i

	if last_update < update_time
		$LOGGER.info 'Generating configuration'
		last_update = Time.now.to_i
		template_generator.generate($SERVER)
	end
end
