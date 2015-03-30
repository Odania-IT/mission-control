require 'rails_helper'

RSpec.describe Api::RepositoriesController, :type => :controller do
	before (:each) do
		@repository = create(:repository)
	end

	it 'lists all repositories' do
		get :index, {format: :json}
		expect(response).to be_success
		expect(response.header['Content-Type']).to include 'application/json'
		expect(assigns(:repositories)).to be_a(Mongoid::Criteria)
		expect(response).to render_template('api/repositories/index')
	end

	it 'should return repository' do
		get :show, {id: @repository.id.to_s, format: :json}

		expect(response).to be_success
		expect(response).to render_template('api/repositories/show')
	end

	it 'should create an repository image' do
		repository = build(:repository)
		assert_difference 'Repository.count' do
			post :create, {format: :json, repository: {
								name: repository.name, url: repository.url, user: repository.user, password: repository.password
							}}
		end

		expect(response).to be_success
		expect(response).to render_template('api/repositories/show')
	end

	it 'should update repository' do
		repository = build(:repository)
		put :update, {id: @repository.id.to_s, format: :json, repository: {
						  name: repository.name, url: repository.url, user: repository.user, password: repository.password
					  }}

		expect(response).to be_success
		expect(response).to render_template('api/repositories/show')
	end

	it 'should destroy repository' do
		assert_difference 'Repository.count', -1 do
			delete :destroy, {id: @repository.id.to_s, format: :json}
		end

		expect(response).to be_success
	end
end
