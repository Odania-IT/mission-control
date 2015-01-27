class Public::WelcomeController < ApplicationController
	def index
	end

	def view
		@view = params[:view].to_s.gsub(/[^a-z0-9\/]/, '_')
		render layout: nil
	end
end
