class Api::TemplatesController < ApiController
	before_action :validate_template, except: [:index, :create]

	def index
		@templates = Template.order([:name, :asc])
	end

	def show
	end

	def create
		@template = Template.new(template_params)
		cleanup_array

		if @template.save
			flash[:notice] = 'Template created'
			render action: :show
		else
			render json: {errors: @template.errors}, status: :bad_request
		end
	end

	def update
		cleanup_array
		if @template.update(template_params)
			flash[:notice] = 'Template updated'
			render action: :show
		else
			render json: {errors: @template.errors}, status: :bad_request
		end
	end

	def destroy
		@template.destroy
		flash[:notice] = 'Template deleted'
		render json: {message: 'deleted'}
	end

	private

	def validate_template
		@template = Template.where(_id: params[:id]).first
		bad_api_request('invalid_template') if @template.nil?
	end

	def template_params
		params.require(:template).permit(:name, :scalable, :backup_strategy, images: [], volumes: [], ports: [], environment: [])
	end

	def cleanup_array
		if template_params[:volumes].nil?
			@template.volumes = []
		end
		if template_params[:ports].nil?
			@template.ports = []
		end
		if template_params[:environment].nil?
			@template.environment = []
		end
		if template_params[:images].nil?
			@template.images = []
		end
	end
end
