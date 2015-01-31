require 'rails_helper'

RSpec.describe Application, :type => :model do
	it 'does not allow an empty domain' do
		expect(build(:application, domains: ['www.example.com', ''])).not_to be_valid
	end

	it 'should allow valid domains' do
		expect(build(:application, domains: %w(www.example.com www.example.org))).to be_valid
	end
end
