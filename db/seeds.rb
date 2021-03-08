# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
Admin.find_or_create_by(id: 1) do |admin|
 admin.email = "sample@sample.com"
 admin.password = "samplesample"



 PostBook.create!(
 [
  {
   user_id: 6,
   genre_id: 3,
   title: "マーケティング",
   content: "この本では、マーケティングのための調査体型を1から教えてくれます。",
   post_book_title: "マーケティングリサーチ",
   post_book_author: "上田拓治",
   post_book_image_id: nil
   }
 ]
 )
end