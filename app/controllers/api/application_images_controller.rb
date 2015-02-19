class Api::ApplicationImagesController < ApiController
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
		params.require(:image).permit(:name, :image, :image_type, :scalable, volumes: [], ports: [], links: [], environment: [])
	end

	def cleanup_array
		if image_params[:volumes].nil?
			@image.volumes = []
		end
		if image_params[:ports].nil?
			@image.ports = []
		end
		if image_params[:links].nil?
			@image.links = []
		end
		if image_params[:environment].nil?
			@image.environment = []
		end
	end
end
