class Api::ApplicationLogsController < ApiController
	def index
		@application_logs = ApplicationLog.order([:created_at, :desc]).page(params[:page]).per(Kaminari.config.default_per_page)
	end
end
