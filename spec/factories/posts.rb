FactoryBot.define do
  factory :post do
    title { Faker::Name.unique.name  }
    main_url { "http://test.com" }
  end
end
