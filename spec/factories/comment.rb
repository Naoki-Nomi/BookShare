FactoryBot.define do
  factory :comment do
    comment_content { Faker::Lorem.characters(number: 200) }
    user
    post_book
  end
end
