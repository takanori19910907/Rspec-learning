FactoryBot.define do
  factory :user, aliases: [:owner] do
    first_name   "Takanori"
    last_name    "Ariyoshi"
    sequence(:email) { |n| "tester#{n}@example.com" }
    password     "testpass"
  end
end
