class Protected::ApplicationsController < ApplicationController
	before_action :set_application, only: [:show, :edit, :update, :destroy]

	# GET /protected/applications
	# GET /protected/applications.json
	def index
		@applications = Application.all
	end

	# GET /protected/applications/1
	# GET /protected/applications/1.json
	def show
	end

	# GET /protected/applications/new
	def new
		@application = Application.new
	end

	# GET /protected/applications/1/edit
	def edit
	end

	# POST /protected/applications
	# POST /protected/applications.json
	def create
		@application = Application.new(application_params)

		respond_to do |format|
			if @application.save
				format.html { redirect_to protected_applications_path, notice: 'Application was successfully created.' }
				format.json { render :show, status: :created, location: @application }
			else
				format.html { render :new }
				format.json { render json: @application.errors, status: :unprocessable_entity }
			end
		end
	end

	# PATCH/PUT /protected/applications/1
	# PATCH/PUT /protected/applications/1.json
	def update
		respond_to do |format|
			if @application.update(application_params)
				format.html { redirect_to protected_applications_path, notice: 'Application was successfully updated.' }
				format.json { render :show, status: :ok, location: @application }
			else
				format.html { render :edit }
				format.json { render json: @application.errors, status: :unprocessable_entity }
			end
		end
	end

	# DELETE /protected/applications/1
	# DELETE /protected/applications/1.json
	def destroy
		@application.destroy
		respond_to do |format|
			format.html { redirect_to applications_url, notice: 'Application was successfully destroyed.' }
			format.json { head :no_content }
		end
	end

	private
	# Use callbacks to share common setup or constraints between actions.
	def set_application
		@application = Application.find(params[:id])
	end

	# Never trust parameters from the scary internet, only allow the white list through.
	def application_params
		params.require(:application).permit(:name, domains: [])
	end
end
