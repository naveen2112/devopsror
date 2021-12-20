FactoryBot.define do
  factory :card do
    last_four_digits { "4242" }
    expiry { "9/2026" }
    token { "tok_1K7dQqGm7mBiaCNXoIeN8pnt" }
    stripe_card_id { "card_1K7dQqGm7mBiaCNXgOxR8tiZ" }
  end
end
