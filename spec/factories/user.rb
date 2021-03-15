FactoryBot.define do
  factory :user do
    nickname { Faker::Lorem.characters(number: 10) }
    introduction { Faker::Lorem.characters(number: 200) }
    email { Faker::Internet.email }
    password { 'password' }
    password_confirmation { 'password' }
  end
end