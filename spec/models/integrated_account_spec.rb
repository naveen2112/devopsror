require 'rails_helper'

RSpec.describe IntegratedAccount, type: :model do
  it { should belong_to(:user) }
  it { should define_enum_for(:platform_name).with_values([:facebook, :twitter, :linked_in]) }
end
