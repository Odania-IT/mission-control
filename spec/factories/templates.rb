FactoryGirl.define do
	factory :template do
		sequence(:name) { |n| "Name #{n}" }
		sequence(:description) { |n| "Description #{n}" }
		images %w(image/1 image/2)
		volumes []
		ports []
		environment []
		scalable false
	end

end
