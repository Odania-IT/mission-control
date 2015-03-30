require 'rails_helper'

RSpec.describe Api::BackgroundSchedulesController, :type => :controller do
	before (:each) do
		@background_schedule = create(:background_schedule)
	end

	it 'lists all background_schedules' do
		get :index, {format: :json}
		expect(response).to be_success
		expect(response.header['Content-Type']).to include 'application/json'
		expect(assigns(:background_schedules)).to be_a(Mongoid::Criteria)
		expect(response).to render_template('api/background_schedules/index')
	end

	it 'should return background_schedule' do
		get :show, {id: @background_schedule.id.to_s, format: :json}

		expect(response).to be_success
		expect(response).to render_template('api/background_schedules/show')
	end

	it 'should create an background_schedule image' do
		background_schedule = build(:background_schedule)
		assert_difference 'BackgroundSchedule.count' do
			post :create, {format: :json, background_schedule: {
								name: background_schedule.name, image_id: @background_schedule.image_id.to_s, cron_times: background_schedule.cron_times,
								strategy: background_schedule.strategy, cron_type: background_schedule.cron_type, server_id: @background_schedule.server_id.to_s,
								backup_server_id: @background_schedule.backup_server_id.to_s
							}}
		end

		expect(response).to be_success
		expect(response).to render_template('api/background_schedules/show')
	end

	it 'should update background_schedule' do
		background_schedule = build(:background_schedule)
		put :update, {id: @background_schedule.id.to_s, format: :json, background_schedule: {
						  name: background_schedule.name, image_id: background_schedule.image_id.to_s, cron_times: background_schedule.cron_times,
						  strategy: background_schedule.strategy, cron_type: background_schedule.cron_type, server_id: @background_schedule.server_id.to_s
					  }}

		expect(response).to be_success
		expect(response).to render_template('api/background_schedules/show')
	end

	it 'should destroy background_schedule' do
		assert_difference 'BackgroundSchedule.count', -1 do
			delete :destroy, {id: @background_schedule.id.to_s, format: :json}
		end

		expect(response).to be_success
	end
end
