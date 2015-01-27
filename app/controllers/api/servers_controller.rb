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

	private

	def validate_server
		@server = Server.where(_id: params[:id]).first
		bad_api_request('invalid_server') if @server.nil?
	end

	def server_params
		params.require(:server).permit(:name, :hostname, :ip, :memory, :cpu, :active)
	end
end
