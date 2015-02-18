class Api::ImagesController < ApiController
	def index
		@images = Image.order([:name, :asc])
	end
end
