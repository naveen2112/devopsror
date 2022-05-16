require 'rails_helper'

RSpec.describe PostUserShare, type: :model do
  it { should belong_to(:company) }
  it { should belong_to(:post) }
  it { should belong_to(:user) }
end
