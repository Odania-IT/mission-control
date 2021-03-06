class Api::ServersController < ApiController
	before_action :validate_server, except: [:index, :create]

	def index
		@servers = Server.order([:name, :asc])
	end

	def show
	end

	def create
		@server = Server.new(server_params)

		if @server.save
			flash[:notice] = 'Server created'
			render action: :show
		else
			render json: {errors: @server.errors}, status: :bad_request
		end
	end

	def update
		if @server.update(server_params)
			flash[:notice] = 'Server updated'
			render action: :show
		else
			render json: {errors: @server.errors}, status: :bad_request
		end
	end

	def destroy
		@server.destroy
		flash[:notice] = 'Server deleted'
		render json: {message: 'deleted'}
	end

	# Add application and all associated containers to the server
	def add_application
		@application = Application.where(_id: params[:application_id]).first
		return bad_api_request('invalid_application') if @application.nil?

		return bad_api_request('Application already added') unless @server.applications.where(_id: params[:application_id]).count == 0

		@server.applications << @application

		ScaleHelper.add_application_on_server(@server, @application)
		DockerChange.check_instances(@server)

		render action: :show
	end

	# Remove application and all associated containers from the server
	def remove_application
		@application = @server.applications.where(_id: params[:application_id]).first
		@server.applications.delete @application
		ScaleHelper.remove_application_on_server(@server, @application)
		DockerChange.check_instances(@server)

		render action: :show
	end

	private

	def validate_server
		@server = Server.where(_id: params[:id]).first
		bad_api_request('invalid_server') if @server.nil?
	end

	def server_params
		params.require(:server).permit(:name, :hostname, :ip, :memory, :cpu, :active, :basic_auth, :volumes_path, :proxy_type, :backup_path)
	end
end
