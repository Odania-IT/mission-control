require 'rails_helper'

RSpec.describe Api::ImagesController, :type => :controller do
	before :each do
		create_list(:image, 25)
	end

	it 'should return images' do
		get :index, {format: :json}

		expect(response).to be_success
		expect(response).to render_template('api/images/index')
	end
end
