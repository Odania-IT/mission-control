require 'rails_helper'

RSpec.describe Api::TemplatesController, :type => :controller do
	before (:each) do
		@template = create(:template)
	end

	it 'lists all templates' do
		get :index, {format: :json}
		expect(response).to be_success
		expect(response.header['Content-Type']).to include 'application/json'
		expect(assigns(:templates)).to be_a(Mongoid::Criteria)
		expect(response).to render_template('api/templates/index')
	end

	it 'should return template' do
		get :show, {id: @template.id.to_s, format: :json}

		expect(response).to be_success
		expect(response).to render_template('api/templates/show')
	end

	it 'should create an template image' do
		template = build(:template)
		assert_difference 'Template.count' do
			post :create, {format: :json, template: {
								name: template.name, description: template.description, images: template.images, volumes: template.volumes, ports: template.ports, environment: template.environment, scalable: true
							}}
		end

		expect(response).to be_success
		expect(response).to render_template('api/templates/show')
	end

	it 'should update template' do
		template = build(:template)
		put :update, {id: @template.id.to_s, format: :json, template: {
						  name: template.name, description: template.description, images: template.images, volumes: template.volumes, ports: template.ports, environment: template.environment, scalable: true
					  }}

		expect(response).to be_success
		expect(response).to render_template('api/templates/show')
	end

	it 'should destroy template' do
		assert_difference 'Template.count', -1 do
			delete :destroy, {id: @template.id.to_s, format: :json}
		end

		expect(response).to be_success
	end
end
