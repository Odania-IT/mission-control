# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
	factory :container, :class => 'Container' do
		current_instances 0
		wanted_instances 1
		status :down
		scalable true
		last_check Time.now
	end
end
