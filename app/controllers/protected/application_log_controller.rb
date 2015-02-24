class Protected::ApplicationLogController < ApplicationController
	def index
		@application_logs = ApplicationLog.order([:created_at, :desc]).page(params[:page]).per(50)
	end
end
