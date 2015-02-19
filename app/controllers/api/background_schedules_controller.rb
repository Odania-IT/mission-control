class Api::BackgroundSchedulesController < ApiController
	before_action :validate_background_schedule, except: [:index, :create]

	def index
		@background_schedules = BackgroundSchedule.order([:name, :asc])
	end

	def show
	end

	def create
		@background_schedule = BackgroundSchedule.new(background_schedule_params)

		if @background_schedule.save
			flash[:notice] = 'Background Schedule created'
			render action: :show
		else
			render json: {errors: @background_schedule.errors}, status: :bad_request
		end
	end

	def update
		if @background_schedule.update(background_schedule_params)
			flash[:notice] = 'Background Schedule updated'
			render action: :show
		else
			render json: {errors: @background_schedule.errors}, status: :bad_request
		end
	end

	def destroy
		@background_schedule.destroy

		flash[:notice] = 'Background Schedule deleted'
		render json: {message: 'deleted'}
	end

	private

	def validate_background_schedule
		@background_schedule = BackgroundSchedule.where(_id: params[:id]).first
		bad_api_request('invalid_backup_schedule') if @background_schedule.nil?
	end

	def background_schedule_params
		params.require(:background_schedule).permit(:name, :cron_type, :cron_times, :server_id, :image_id, :strategy)
	end
end
