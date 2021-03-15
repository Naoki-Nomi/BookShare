FactoryBot.define do
  factory :book do
    book_title { Faker::Lorem.characters(number:10) }
    author { Faker::Lorem.characters(number:5) }
    note { Faker::Lorem.characters(number:100) }
    read_date { Faker::Date.between(from: '2020-10-01', to: '2021-02-28') }
    user
    genre
  end
end