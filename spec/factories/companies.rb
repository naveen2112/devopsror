FactoryBot.define do
  factory :company do
    name { Faker::Name.unique.name }
    url { "http://test.com" }
  end
end