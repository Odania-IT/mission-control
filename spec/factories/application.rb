# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
	factory :application, :class => 'Application' do
		sequence(:name) { |n| "Name #{n}" }
		sequence(:domains) { |n| ["www.domain#{n}.com"] }
		do_destroy false
	end
end
