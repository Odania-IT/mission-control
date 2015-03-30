# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
	factory :image, :class => 'Image' do
		sequence(:name) { |n| "Name #{n}" }
		image_type :background
		sequence(:image) { |n| "image:#{n}" }
		scalable true
		application

		factory :exposed_image do
			image_type :expose
		end
	end
end
