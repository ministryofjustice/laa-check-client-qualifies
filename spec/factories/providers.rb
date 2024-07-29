FactoryBot.define do
  factory :provider do
    email { Faker::Internet.email }
    first_office_code { Faker::Alphanumeric.alpha }
  end
end
