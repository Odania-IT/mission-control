require 'rails_helper'

RSpec.describe Api::ServersController, :type => :controller do
	before (:each) do
		@application = create(:application)
	end

	it 'lists all servers' do
		get :index, {format: :json}
		expect(response).to be_success
		expect(response.header['Content-Type']).to include 'application/json'
		expect(assigns(:servers)).to be_a(Mongoid::Criteria)
		expect(response).to render_template('api/servers/index')
	end

	it 'sends a docker change if application is added' do
	end

	
end
