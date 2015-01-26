class Protected::ServersController < ApplicationController
	before_action :set_protected_server, only: [:show, :edit, :update, :destroy]

	# GET /protected/servers
	# GET /protected/servers.json
	def index
		@servers = Server.all
	end

	# GET /protected/servers/1
	# GET /protected/servers/1.json
	def show
	end

	# GET /protected/servers/new
	def new
		@protected_server = Server.new
	end

	# GET /protected/servers/1/edit
	def edit
	end

	# POST /protected/servers
	# POST /protected/servers.json
	def create
		@protected_server = Server.new(protected_server_params)

		respond_to do |format|
			if @protected_server.save
				format.html { redirect_to @protected_server, notice: 'Server was successfully created.' }
				format.json { render :show, status: :created, location: @protected_server }
			else
				format.html { render :new }
				format.json { render json: @protected_server.errors, status: :unprocessable_entity }
			end
		end
	end

	# PATCH/PUT /protected/servers/1
	# PATCH/PUT /protected/servers/1.json
	def update
		respond_to do |format|
			if @protected_server.update(protected_server_params)
				format.html { redirect_to @protected_server, notice: 'Server was successfully updated.' }
				format.json { render :show, status: :ok, location: @protected_server }
			else
				format.html { render :edit }
				format.json { render json: @protected_server.errors, status: :unprocessable_entity }
			end
		end
	end

	# DELETE /protected/servers/1
	# DELETE /protected/servers/1.json
	def destroy
		@protected_server.destroy
		respond_to do |format|
			format.html { redirect_to servers_url, notice: 'Server was successfully destroyed.' }
			format.json { head :no_content }
		end
	end

	private
	# Use callbacks to share common setup or constraints between actions.
	def set_protected_server
		@protected_server = Server.find(params[:id])
	end

	# Never trust parameters from the scary internet, only allow the white list through.
	def protected_server_params
		params.require(:protected_server).permit(:name, :hostname, :ip, :memory, :cpu, :active)
	end
end
