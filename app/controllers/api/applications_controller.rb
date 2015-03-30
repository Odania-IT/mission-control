class Api::ApplicationsController < ApiController
	include CleanupArray

	before_action :validate_application, except: [:index, :create, :get_global_application]

	def index
		@applications = Application.order([:name, :asc])
	end

	def show
	end

	def create
		@application = Application.new(application_params)
		cleanup_array

		if @application.save
			flash[:notice] = 'Application created'
			render action: :show
		else
			render json: {errors: @application.errors}, status: :bad_request
		end
	end

	def update
		cleanup_array
		if @application.update(application_params)
			flash[:notice] = 'Application updated'
			render action: :show
		else
			render json: {errors: @application.errors}, status: :bad_request
		end
	end

	def destroy
		# Remove from all servers
		@application.servers.each do |server|
			ScaleHelper.remove_application_on_server(server, @application)
		end

		# Set application to destroy
		@application.do_destroy = true
		@application.save!

		flash[:notice] = 'Application deleted'
		render json: {message: 'deleted'}
	end

	def get_global_application
		@application = Application.where(is_global: true).first
		@application = Application.create!(is_global: true, name: 'Global') if @application.nil?

		render action: :show
	end

	private

	def validate_application
		@application = Application.where(_id: params[:id]).first
		bad_api_request('invalid_application') if @application.nil?
	end

	def application_params
		params.require(:application).permit(:name, :basic_auth, domains: [], ports: [])
	end

	def cleanup_array
		do_cleanup_array(@application, application_params, [:domains])
	end
end
