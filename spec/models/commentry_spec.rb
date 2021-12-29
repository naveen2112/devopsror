require 'rails_helper'

RSpec.describe Commentry, type: :model do

  it { should belong_to(:post) }
  it { should validate_presence_of(:description) }
end
