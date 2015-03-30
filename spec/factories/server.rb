# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
	factory :server, :class => 'Server' do
		sequence(:name) { |n| "Name #{n}" }
		sequence(:hostname) { |n| "hostname#{n}" }
		sequence(:ip) { |n| "127.0.0.#{n}" }
		sequence(:memory) { |n| n }
		cpu 2
		os 'Unknown'
	end
end
