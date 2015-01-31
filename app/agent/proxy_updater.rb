$SCRIPT_TYPE = 'Proxy Updater'
require_relative './lib/bootstrap'

template_generator = TemplateGenerator.new

# Generate first config
template_generator.generate($SERVER)

do_shutdown = false
last_update = Time.now.to_i

while not do_shutdown
	# Check if the capped collection exists
	moped_session = Mongoid::Sessions.default
	#moped_session.command(create: 'docker_changes', capped: true, size: 10000000, max: 1000)
	moped_session[:docker_changes].insert({ 'name' => 'create'})
	moped_session[:docker_changes].find.each do |elem|
		puts elem.inspect
	end
	cursor = moped_session[:docker_changes].find.tailable.cursor

	puts cursor.inspect
	docker_change = cursor.next
	puts docker_change.inspect

	if last_update < update_time
		$LOGGER.info 'Generating configuration'
		last_update = Time.now.to_i
		template_generator.generate($SERVER)
	end
end
