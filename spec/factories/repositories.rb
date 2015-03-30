FactoryGirl.define do
	factory :repository do
		sequence(:name) {|n| "Name #{n}"}
		url "MyString"
		user "MyString"
		password "MyString"
	end

end
