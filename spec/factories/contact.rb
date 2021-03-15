FactoryBot.define do
  factory :contact do
    name { Faker::Lorem.characters(number: 5) }
    email { Faker::Internet.email }
    content { Faker::Lorem.characters(number: 100) }
  end
end