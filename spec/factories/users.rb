FactoryBot.define do
  factory :user do
    account { Faker::Lorem.characters(number: 10) }
    email { Faker::Internet.email }
    password { 'password' }
  end
end
