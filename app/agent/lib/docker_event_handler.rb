class DockerEventHandler
	attr_accessor :hostname, :server

	def initialize(server)
		self.hostname = Docker.info['Name']
		self.server = server
	end

	def handle(event)
		$LOGGER.debug 'handle'
		puts event.inspect
		mongo_docker_container = self.server.docker_containers.where(id: event.id).first
		puts mongo_docker_container.inspect

		app = self.identify_app.identify(event)
		$LOGGER.debug "app: #{mongo_docker_container.inspect}"

		if event.status.eql? 'start'
			# Starting a new container
			self.config_store.hset("app:#{app.name}:#{self.hostname}", app.id, app.to_json)
			self.config_store.rpush("update_config:#{Docker.info['Name']}", Time.now.to_i)
			self.config_store.rpush("app:started:#{Docker.info['Name']}", app.id)
		elsif %w(stop kill die).include? event.status
			# Stopping an container
			self.config_store.hdel("app:#{app.name}:#{self.hostname}", app.id)
			self.config_store.rpush("update_config:#{Docker.info['Name']}", Time.now.to_i)
			self.config_store.rpush("app:stopped:#{Docker.info['Name']}", app.id)
		end
	end
end
