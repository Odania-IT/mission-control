FactoryGirl.define do
	factory :backup_server do
		sequence(:name) {|n| "Name #{n}"}
		backup_type 'ftp'
		url "MyString"
		user "MyString"
		password "MyString"
	end

end
