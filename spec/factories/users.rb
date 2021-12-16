FactoryBot.define do
  factory :user do
    email { Faker::Internet.unique.email }
    password { '123qwe123' }
    first_name { Faker::Name.first_name  }
    last_name { Faker::Name.last_name  }
    association :company, factory: :company
  end
end
