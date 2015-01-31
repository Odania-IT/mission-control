class DockerEventHandler
	attr_accessor :hostname, :server

	def initialize(server)
		self.hostname = Docker.info['Name']
		self.server = server
	end

	def handle(event)
		$LOGGER.debug 'handle'
		puts event.inspect
		server_container = self.server.server_containers.where(docker_id: event.id).first

		# Check if this is a monitored container
		if server_container.nil?
			# Log this container on the server
			server_container = self.server.server_containers.build
			server_container.docker_id = event.id
			server_container.image = event.from
			server_container.is_managed = false
		end

		if event.status.eql? 'start'
			# Starting a new container
			server_container.status = :up
		elsif %w(stop kill die).include? event.status
			# Stopping an container
			server_container.status = :down
		end
		self.server.save!

		if server_container.is_managed
			docker_change = DockerChange.new
			docker_change.update_proxy = true
			docker_change.save!
		end
	end
end