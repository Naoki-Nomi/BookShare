FactoryBot.define do
  factory :post_book do
    post_book_title { Faker::Lorem.characters(number:10) }
    post_book_author { Faker::Lorem.characters(number:5) }
    title { Faker::Lorem.characters(number:15) }
    content { Faker::Lorem.characters(number:300)  }
    user
    genre
  end
end