require 'rails_helper'

RSpec.describe Import, type: :model do
  it { should belong_to(:company) }
  it { should have_one_attached(:file) }
  it { should have_one_attached(:error_file) }
end
