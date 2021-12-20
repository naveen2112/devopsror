require 'rails_helper'

RSpec.describe Card, type: :model do
  it { should belong_to(:user) }
  it { should validate_presence_of(:last_four_digits) }
  it { should validate_presence_of(:expiry) }
  it { should validate_presence_of(:token) }
end
