require 'rails_helper'

RSpec.describe User, type: :model do

  it { should belong_to(:company) }
  it { should validate_presence_of(:first_name) }
  it { should validate_uniqueness_of(:email).ignoring_case_sensitivity }
  it { should accept_nested_attributes_for(:company) }
  it { should have_many(:cards) }
  it { should define_enum_for(:role).with_values([:admin, :editor,  :poster]) }
end