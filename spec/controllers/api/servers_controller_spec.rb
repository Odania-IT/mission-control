require 'rails_helper'

RSpec.describe Api::ServersController, :type => :controller do
	before (:each) do
		@server = create(:server)
	end

	it 'lists all servers' do
		get :index, {format: :json}
		expect(response).to be_success
		expect(response.header['Content-Type']).to include 'application/json'
		expect(assigns(:servers)).to be_a(Mongoid::Criteria)
		expect(response).to render_template('api/servers/index')
	end

	it 'should return server' do
		get :show, {id: @server.id.to_s, format: :json}

		expect(response).to be_success
		expect(response).to render_template('api/servers/show')
	end

	it 'should create an server' do
		server = build(:server)
		assert_difference 'Server.count' do
			post :create, {format: :json, server: {
									name: server.name, hostname: server.hostname, ip: server.ip, memory: server.memory, cpu: server.cpu,
									os: server.os, active: true, basic_auth: server.basic_auth, volumes_path: server.volumes_path,
									backup_path: server.backup_path, proxy_type: server.proxy_type
								}}
		end

		expect(response).to be_success
		expect(response).to render_template('api/servers/show')
	end

	it 'should update server' do
		server = build(:server)
		put :update, {id: @server.id.to_s, format: :json, server: {
						name: server.name, hostname: server.hostname, ip: server.ip, memory: server.memory, cpu: server.cpu,
						os: server.os, active: false, basic_auth: server.basic_auth, volumes_path: server.volumes_path,
						backup_path: server.backup_path, proxy_type: server.proxy_type
					}}

		expect(response).to be_success
		expect(response).to render_template('api/servers/show')
	end

	it 'should destroy server' do
		assert_difference 'Server.count', -1 do
			delete :destroy, {id: @server.id.to_s, format: :json}
		end

		expect(response).to be_success
	end

	it 'should add aplication' do
		application = create(:application)
		post :add_application, {id: @server.id.to_s, application_id: application.id, format: :json}

		@server.reload
		expect(response).to be_success
		expect(@server.applications.where(_id: application.id).count).to be(1)
	end

	it 'should remove application' do
		application = create(:application)
		@server.applications << application
		post :remove_application, {id: @server.id.to_s, application_id: application.id, format: :json}

		@server.reload
		expect(response).to be_success
		expect(@server.applications.where(_id: application.id).count).to be(0)
	end

end
