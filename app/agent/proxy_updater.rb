$SCRIPT_TYPE = 'Proxy Updater'
require_relative './lib/bootstrap'

unless AgentHelper.module_exists?('Rails')
	template_generator = TemplateGenerator.new
	whenever_schedule_generator = WheneverScheduleGenerator.new($SERVER)

	# Get Last entry
	docker_change = DockerChange.order([:created_at, :desc]).first
	last_update = docker_change.nil? ? Time.now : docker_change.created_at

	# Generate first config
	template_generator.generate($SERVER)
	whenever_schedule_generator.generate

	# Additionally perform timed checks
	Thread.new do
		sleep 60
		template_generator.generate($SERVER)
	end

	moped_session = Mongoid::Sessions.default
	query = moped_session[:docker_changes].find(created_at: {'$gt' => last_update}).tailable
	cursor = query.cursor

	# Retrieve every line and update if necessary
	cursor.each do |entry|
		if entry['server_id'].to_s.eql?($SERVER.id.to_s) and entry['update_proxy']
			$LOGGER.info '[Proxy Updater] Generating configuration'
			template_generator.generate($SERVER)
		elsif entry['server_id'].to_s.eql?($SERVER.id.to_s) and entry['update_schedule']
			$LOGGER.info '[Proxy Updater] Generating schedule'
			whenever_schedule_generator.generate
		else
			$LOGGER.debug "[Proxy Updater] Not processing: Correct Server? #{entry['server_id'].to_s.eql?($SERVER.id.to_s)} | update_proxy: #{entry['update_proxy']}"
		end
	end
end
