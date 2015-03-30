class Api::ApplicationImagesController < ApiController
	include CleanupArray

	before_action :validate_application
	before_action :validate_image, except: [:index, :create]

	def index
		@images = Image.order([:name, :asc])
	end

	def show
	end

	def create
		@image = Image.new(image_params)
		@image.application_id = @application.id
		@image.is_global = @application.is_global
		cleanup_array
		update_template_environment

		if @image.save
			@application.servers.each do |server|
				ScaleHelper.add_application_on_server(server, @application)
			end

			flash[:notice] = 'Image created'
			render action: :show
		else
			render json: {errors: @image.errors}, status: :bad_request
		end
	end

	def update
		cleanup_array
		if @image.update(image_params)
			update_template_environment
			@image.save!

			@application.servers.each do |server|
				ScaleHelper.add_application_on_server(server, @application)
			end

			flash[:notice] = 'Image updated'
			render action: :show
		else
			render json: {errors: @image.errors}, status: :bad_request
		end
	end

	def destroy
		@image.containers.each do |container|
			container.status = :destroy
			container.save!
		end

		@image.destroy
		flash[:notice] = 'Image deleted'
		render json: {message: 'deleted'}
	end

	private

	def validate_application
		@application = Application.where(_id: params[:application_id]).first
		bad_api_request('invalid_application') if @application.nil?
	end

	def validate_image
		@image = @application.images.where(_id: params[:id]).first
		bad_api_request('invalid_image') if @image.nil?
	end

	def image_params
		params.require(:image).permit(:name, :image, :image_type, :scalable, :template_id, volumes: [], ports: [],
												links: [], environment: [])
	end

	def cleanup_array
		do_cleanup_array(@image, image_params, [:volumes, :ports, :links, :environment])
	end

	def update_template_environment
		if params[:image][:template_environment] and !@image.template.nil?
			@image.template_environment = {}

			@image.template.environment.each do |environment|
				@image.template_environment[environment] = params[:image][:template_environment][environment]
			end
		end
	end
end
