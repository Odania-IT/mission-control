require 'rails_helper'

RSpec.describe Container, :type => :model do
	it 'should not allow invalid status' do
		expect(build(:container, status: :invalid)).not_to be_valid
	end
end
