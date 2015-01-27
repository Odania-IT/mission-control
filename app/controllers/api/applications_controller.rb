class Api::ApplicationsController < ApiController
	before_action :validate_application, except: [:index, :create]

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
		@application.destroy
		flash[:notice] = 'Application deleted'
		render json: {message: 'deleted'}
	end

	private

	def validate_application
		@application = Application.where(_id: params[:id]).first
		bad_api_request('invalid_application') if @application.nil?
	end

	def application_params
		params.require(:application).permit(:name, domains: [])
	end

	def cleanup_array
		if application_params[:domains].nil?
			@application.domains = []
		end
	end
end
