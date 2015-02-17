class Api::ContainersController < ApiController
	before_action :validate_server_and_container

	def update
		@container.update(container_params)

		# Let the agent check the instances
		@container.servers.each do |server|
			DockerChange.check_instances(server)
		end
	end

	private

	def validate_server_and_container
		@server = Server.where(_id: params[:server_id]).first
		return bad_api_request('invalid_server') if @server.nil?

		@container = @server.containers.where(_id: params[:id]).first
		return bad_api_request('invalid_container') if @container.nil?
	end

	def container_params
		params.require(:container).permit(:wanted_instances)
	end
end
