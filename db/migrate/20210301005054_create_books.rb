class CreateBooks < ActiveRecord::Migration[5.2]
  def change
    create_table :books do |t|
      t.integer :user_id
      t.integer :genre_id
      t.string :book_title
      t.string :author
      t.text :note
      t.date :read_date

      t.timestamps
    end
  end
end
