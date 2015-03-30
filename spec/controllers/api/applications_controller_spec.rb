require 'rails_helper'

RSpec.describe Api::ApplicationsController, :type => :controller do
	before (:each) do
		@application = create(:application)
	end

	it 'lists all applications' do
		get :index, {format: :json}
		expect(response).to be_success
		expect(response.header['Content-Type']).to include 'application/json'
		expect(assigns(:applications)).to be_a(Mongoid::Criteria)
		expect(response).to render_template('api/applications/index')
	end

	it 'should return application' do
		get :show, {id: @application.id.to_s, format: :json}

		expect(response).to be_success
		expect(response).to render_template('api/applications/show')
	end

	it 'should create an application image' do
		application = build(:application)
		assert_difference 'Application.count' do
			post :create, {format: :json, application: {
								name: application.name, basic_auth: application.basic_auth, domains: application.domains, ports: application.ports
							}}
		end

		expect(response).to be_success
		expect(response).to render_template('api/applications/show')
	end

	it 'should update application' do
		application = build(:application)
		put :update, {id: @application.id.to_s, format: :json, application: {
						  name: application.name, basic_auth: application.basic_auth, domains: application.domains, ports: application.ports
					  }}

		expect(response).to be_success
		expect(response).to render_template('api/applications/show')
	end

	it 'should destroy application' do
		delete :destroy, {id: @application.id.to_s, format: :json}

		@application.reload
		expect(response).to be_success
		expect(@application.do_destroy).to be(true)
	end
end
