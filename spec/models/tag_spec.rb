require 'rails_helper'

RSpec.describe Tag, type: :model do

  it { should belong_to(:company) }
  it { should validate_presence_of(:name) }
  it { should have_and_belong_to_many(:posts) }
end
