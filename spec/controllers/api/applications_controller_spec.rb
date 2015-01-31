require 'rails_helper'

RSpec.describe Api::ApplicationsController, :type => :controller do
	before (:each) do
		@application = create(:application)
	end

	it 'lists all applications' do
		get :index, {format: :json}
	end
end
