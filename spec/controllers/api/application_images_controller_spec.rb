require 'rails_helper'

RSpec.describe Api::ApplicationImagesController, :type => :controller do
	before :each do
		@application = create(:application)
		@image = create(:image, application: @application)
		create_list(:image, 25)
	end

	it 'should return application images' do
		get :index, {application_id: @application.id.to_s, format: :json}

		expect(response).to be_success
		expect(response).to render_template('api/application_images/index')
	end

	it 'should return application image' do
		get :show, {application_id: @application.id.to_s, id: @image.id.to_s, format: :json}

		expect(response).to be_success
		expect(response).to render_template('api/application_images/show')
	end

	it 'should create an application image' do
		image = build(:image)
		assert_difference 'Image.count' do
			post :create, {application_id: @application.id.to_s, format: :json, image: {
									name: image.name, image: image.image, image_type: image.image_type, scalable: image.scalable, template_id: image.template_id,
									volumes: image.volumes, ports: image.ports, links: image.links, environment: image.environment
								}}
		end

		expect(response).to be_success
		expect(response).to render_template('api/application_images/show')
	end

	it 'should update application image' do
		image = build(:image)
		put :update, {application_id: @application.id.to_s, id: @image.id.to_s, format: :json, image: {
						name: image.name, image: image.image, image_type: image.image_type, scalable: image.scalable, template_id: image.template_id,
						volumes: image.volumes, ports: image.ports, links: image.links, environment: image.environment
					}}

		expect(response).to be_success
		expect(response).to render_template('api/application_images/show')
	end

	it 'should destroy application image' do
		assert_difference 'Image.count', -1 do
			delete :destroy, {application_id: @application.id.to_s, id: @image.id.to_s, format: :json}
		end

		expect(response).to be_success
	end
end
