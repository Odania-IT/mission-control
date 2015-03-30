require 'rails_helper'

RSpec.describe Api::ContainersController, :type => :controller do
	before (:each) do
		@container = create(:container)
	end

	it 'should update container' do
		put :update, {server_id: @container.server_id, id: @container.id.to_s, format: :json, container: {
						  wanted_instances: rand(10)+1
					  }}

		expect(response).to be_success
		expect(response).to render_template('api/containers/update')
	end
end
