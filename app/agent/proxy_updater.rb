$SCRIPT_TYPE = 'Proxy Updater'
require_relative './lib/bootstrap'

unless AgentHelper.module_exists?('Rails')
	template_generator = TemplateGenerator.new

	# Get Last entry
	docker_change = DockerChange.order([:created_at, :desc]).first
	last_update = docker_change.nil? ? Time.now : docker_change.created_at

	# Generate first config
	template_generator.generate($SERVER)

	moped_session = Mongoid::Sessions.default
	query = moped_session[:docker_changes].find(created_at: {'$gt' => last_update}).tailable
	cursor = query.cursor

	# Retrieve every line and update if necessary
	cursor.each do |entry|
		if entry['server_id'].to_s.eql?($SERVER.id.to_s) and entry['update_proxy']
			$LOGGER.info 'Generating configuration'
			template_generator.generate($SERVER)
		end
	end
end
