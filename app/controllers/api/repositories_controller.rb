class Api::RepositoriesController < ApiController
	before_action :validate_repository, except: [:index, :create]

	def index
		@repositories = Repository.order([:name, :asc])
	end

	def show
	end

	def create
		@repository = Repository.new(repository_params)

		if @repository.save
			flash[:notice] = 'Repository created'
			render action: :show
		else
			render json: {errors: @repository.errors}, status: :bad_request
		end
	end

	def update
		if @repository.update(repository_params)
			flash[:notice] = 'Repository updated'
			render action: :show
		else
			render json: {errors: @repository.errors}, status: :bad_request
		end
	end

	def destroy
		@repository.destroy

		flash[:notice] = 'Repository deleted'
		render json: {message: 'deleted'}
	end

	private

	def validate_repository
		@repository = Repository.where(_id: params[:id]).first
		bad_api_request('invalid_repository') if @repository.nil?
	end

	def repository_params
		params.require(:repository).permit(:name, :url, :user, :password, :active)
	end
end
