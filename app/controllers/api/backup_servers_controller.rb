class Api::BackupServersController < ApiController
	before_action :validate_backup_server, except: [:index, :create]

	def index
		@backup_servers = BackupServer.order([:name, :asc])
	end

	def show
	end

	def create
		@backup_server = BackupServer.new(backup_server_params)

		if @backup_server.save
			flash[:notice] = 'Backup Server created'
			render action: :show
		else
			render json: {errors: @backup_server.errors}, status: :bad_request
		end
	end

	def update
		if @backup_server.update(backup_server_params)
			flash[:notice] = 'Backup Server updated'
			render action: :show
		else
			render json: {errors: @backup_server.errors}, status: :bad_request
		end
	end

	def destroy
		@backup_server.destroy

		flash[:notice] = 'Backup Server deleted'
		render json: {message: 'deleted'}
	end

	private

	def validate_backup_server
		@backup_server = BackupServer.where(_id: params[:id]).first
		bad_api_request('invalid_backup_server') if @backup_server.nil?
	end

	def backup_server_params
		params.require(:backup_server).permit(:name, :url, :user, :password, :backup_type)
	end
end
