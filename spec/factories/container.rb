# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
	factory :container, :class => 'Container' do
		server
		application
		current_instances 0
		wanted_instances 1
		status :down
		scalable true
		last_check Time.now
	end
end
