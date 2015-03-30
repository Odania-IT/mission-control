require 'rails_helper'

RSpec.describe Api::BackupServersController, :type => :controller do
	before (:each) do
		@backup_server = create(:backup_server)
	end

	it 'lists all backup_servers' do
		get :index, {format: :json}
		expect(response).to be_success
		expect(response.header['Content-Type']).to include 'application/json'
		expect(assigns(:backup_servers)).to be_a(Mongoid::Criteria)
		expect(response).to render_template('api/backup_servers/index')
	end

	it 'should return backup_server' do
		get :show, {id: @backup_server.id.to_s, format: :json}

		expect(response).to be_success
		expect(response).to render_template('api/backup_servers/show')
	end

	it 'should create an backup_server image' do
		backup_server = build(:backup_server)
		assert_difference 'BackupServer.count' do
			post :create, {format: :json, backup_server: {
								name: backup_server.name, backup_type: backup_server.backup_type, url: backup_server.url, user: backup_server.user, password: backup_server.password
							}}
		end

		expect(response).to be_success
		expect(response).to render_template('api/backup_servers/show')
	end

	it 'should update backup_server' do
		backup_server = build(:backup_server)
		put :update, {id: @backup_server.id.to_s, format: :json, backup_server: {
						  name: backup_server.name, backup_type: backup_server.backup_type, url: backup_server.url, user: backup_server.user, password: backup_server.password
					  }}

		expect(response).to be_success
		expect(response).to render_template('api/backup_servers/show')
	end

	it 'should destroy backup_server' do
		assert_difference 'BackupServer.count', -1 do
			delete :destroy, {id: @backup_server.id.to_s, format: :json}
		end

		expect(response).to be_success
	end
end
