require 'rails_helper'

RSpec.describe Post, type: :model do

  it { should belong_to(:company) }
  it { should validate_presence_of(:title) }
  it { should accept_nested_attributes_for(:commentries) }
  it { should accept_nested_attributes_for(:tags) }
  it { should have_many(:commentries) }
  it { should have_and_belong_to_many(:tags) }
  it { should have_one_attached(:image) }
end
