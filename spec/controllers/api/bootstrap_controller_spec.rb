require 'rails_helper'

RSpec.describe Api::BootstrapController, :type => :controller do
	it 'should return bootstrap' do
		get :index, {format: :json}
		expect(response).to be_success
		expect(response.header['Content-Type']).to include 'application/json'
		expect(response).to render_template('api/bootstrap/index')
	end
end
