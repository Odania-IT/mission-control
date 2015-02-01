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
end
