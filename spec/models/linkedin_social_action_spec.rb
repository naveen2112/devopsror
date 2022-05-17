require 'rails_helper'

RSpec.describe LinkedinSocialAction, type: :model do
  it { should belong_to(:company) }
  it { should belong_to(:post) }
end
