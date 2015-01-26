class Protected::ImagesController < ApplicationController
	before_action :set_image, only: [:show, :edit, :update, :destroy]

	# GET /protected/images
	# GET /protected/images.json
	def index
		@images = Image.all
	end

	# GET /protected/images/1
	# GET /protected/images/1.json
	def show
	end

	# GET /protected/images/new
	def new
		@image = Image.new
	end

	# GET /protected/images/1/edit
	def edit
	end

	# POST /protected/images
	# POST /protected/images.json
	def create
		@image = Image.new(image_params)

		respond_to do |format|
			if @image.save
				format.html { redirect_to protected_images_path, notice: 'Image was successfully created.' }
				format.json { render :show, status: :created, location: @image }
			else
				format.html { render :new }
				format.json { render json: @image.errors, status: :unprocessable_entity }
			end
		end
	end

	# PATCH/PUT /protected/images/1
	# PATCH/PUT /protected/images/1.json
	def update
		respond_to do |format|
			if @image.update(image_params)
				format.html { redirect_to protected_images_path, notice: 'Image was successfully updated.' }
				format.json { render :show, status: :ok, location: @image }
			else
				format.html { render :edit }
				format.json { render json: @image.errors, status: :unprocessable_entity }
			end
		end
	end

	# DELETE /protected/images/1
	# DELETE /protected/images/1.json
	def destroy
		@image.destroy
		respond_to do |format|
			format.html { redirect_to images_url, notice: 'Image was successfully destroyed.' }
			format.json { head :no_content }
		end
	end

	private
	# Use callbacks to share common setup or constraints between actions.
	def set_image
		@image = Image.find(params[:id])
	end

	# Never trust parameters from the scary internet, only allow the white list through.
	def image_params
		params.require(:image).permit(:name, :image, :image_type, volumes: [], ports: [], links: [], environment: [])
	end
end
