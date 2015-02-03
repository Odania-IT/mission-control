class Api::ContainersController < ApiController
	before_action :validate_server_and_container

	def update
		@container.update(server_container_params)
	end

	private

	def validate_server_and_container
		@server = Server.where(_id: params[:server_id]).first
		return bad_api_request('invalid_server') if @server.nil?

		@container = @server.server_containers.where(_id: params[:id]).first
		return bad_api_request('invalid_server') if @container.nil?
	end

	def server_container_params
		params.require(:container).permit(:wanted_instances)
	end
end
