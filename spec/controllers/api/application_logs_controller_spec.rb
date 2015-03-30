require 'rails_helper'

RSpec.describe Api::ApplicationLogsController, :type => :controller do
	before (:each) do
		create_list(:application_log, 25)
		@application_log = create(:application_log)
	end

	it 'lists all application logs' do
		get :index, {format: :json}
		expect(response).to be_success
		expect(response.header['Content-Type']).to include 'application/json'
		expect(assigns(:application_logs)).to be_a(Mongoid::Criteria)
		expect(response).to render_template('api/application_logs/index')
	end
end
