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
		@server = Server.new
	end

	# GET /protected/servers/1/edit
	def edit
	end

	# POST /protected/servers
	# POST /protected/servers.json
	def create
		@server = Server.new(protected_server_params)

		respond_to do |format|
			if @server.save
				format.html { redirect_to protected_servers_path, notice: 'Server was successfully created.' }
				format.json { render :show, status: :created, location: @server }
			else
				format.html { render :new }
				format.json { render json: @server.errors, status: :unprocessable_entity }
			end
		end
	end

	# PATCH/PUT /protected/servers/1
	# PATCH/PUT /protected/servers/1.json
	def update
		respond_to do |format|
			if @server.update(protected_server_params)
				format.html { redirect_to protected_servers_path, notice: 'Server was successfully updated.' }
				format.json { render :show, status: :ok, location: @server }
			else
				format.html { render :edit }
				format.json { render json: @server.errors, status: :unprocessable_entity }
			end
		end
	end

	# DELETE /protected/servers/1
	# DELETE /protected/servers/1.json
	def destroy
		@server.destroy
		respond_to do |format|
			format.html { redirect_to servers_url, notice: 'Server was successfully destroyed.' }
			format.json { head :no_content }
		end
	end

	private
	# Use callbacks to share common setup or constraints between actions.
	def set_protected_server
		@server = Server.find(params[:id])
	end

	# Never trust parameters from the scary internet, only allow the white list through.
	def protected_server_params
		params.require(:server).permit(:name, :hostname, :ip, :memory, :cpu, :active)
	end
end
