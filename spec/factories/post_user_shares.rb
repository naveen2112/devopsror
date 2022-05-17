FactoryBot.define do
  factory :post_user_share do
    post { nil }
    user { nil }
    share_id { "MyString" }
    engagements_count { 1 }
    click_count { 1 }
  end
end
