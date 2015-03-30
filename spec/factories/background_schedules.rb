FactoryGirl.define do
	factory :background_schedule do
		sequence(:name) { |n| "Name #{n}" }
		strategy { [:mysql, :volumes].sample }
		cron_type 'backup'
		image
		server
		backup_server
		cron_times '* 0 0 0 0'
	end

end
