FactoryBot.define do
  factory :company do
    name { Faker::Name.unique.name }
  end
end