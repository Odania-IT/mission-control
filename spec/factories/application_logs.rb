FactoryGirl.define do
	factory :application_log do
		server
		level { [:debug, :info, :warn, :error].sample }
		category { [:cron, :docker, :backup].sample }
		sequence(:message) {|n| "MyText #{n}"}
		sequence(:file) {|n| "file/a#{n}.rb"}
	end

end
