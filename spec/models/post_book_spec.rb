# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'PostBookモデルのテスト', type: :model do
  describe '実際に保存してみる' do
    it '有効な投稿の場合は保存されるか' do
      expect(FactoryBot.build(:post_book)).to be_valid
    end
  end

  describe 'バリデーションのテスト' do
    let(:user) { create(:user) }
    let(:genre) { create(:genre) }
    let!(:post_book) { build(:post_book, user_id: user.id, genre_id: genre.id) }

    context 'titleカラム' do
      it '空欄の場合にバリデーションチェックされているか' do
        post_book.title = ''
        expect(post_book).to be_invalid
      end
      it '30文字以内であること: 31文字は×' do
        post_book.title = Faker::Lorem.characters(number: 31)
        expect(post_book).to be_invalid
      end
      it '30文字以内であること: 30文字は◎' do
        post_book.title = Faker::Lorem.characters(number: 30)
        expect(post_book).to be_valid
      end
    end
    context 'contentカラム' do
      it '空欄の場合にバリデーションチェックされているか' do
        post_book.content = ''
        expect(post_book).to be_invalid
      end
      it '1200文字以内であること: 1201文字は×' do
        post_book.content = Faker::Lorem.characters(number: 1201)
        expect(post_book).to be_invalid
      end
      it '1200文字以内であること: 1200文字は◎' do
        post_book.content = Faker::Lorem.characters(number: 1200)
        expect(post_book).to be_valid
      end
    end
    context 'post_book_authorカラム' do
      it '空欄の場合にバリデーションチェックされているか' do
        post_book.post_book_author = ''
        expect(post_book).to be_invalid
      end
      it '30文字以内であること: 31文字は×' do
        post_book.post_book_author = Faker::Lorem.characters(number: 31)
        expect(post_book).to be_invalid
      end
      it '30文字以内であること: 30文字は◎' do
        post_book.post_book_author = Faker::Lorem.characters(number: 30)
        expect(post_book).to be_valid
      end
    end

    context 'post_book_titleカラム' do
      it '空欄の場合にバリデーションチェックされているか' do
        post_book.post_book_title = ''
        expect(post_book).to be_invalid
      end
      it '30文字以内であること: 31文字は×' do
        post_book.post_book_title = Faker::Lorem.characters(number: 31)
        expect(post_book).to be_invalid
      end
      it '30文字以内であること: 30文字は◎' do
        post_book.post_book_title = Faker::Lorem.characters(number: 30)
        expect(post_book).to be_valid
      end
    end
  end

  describe 'アソシエーションのテスト' do
    context 'Userモデルとの関係' do
      it 'N:1となっている' do
        expect(PostBook.reflect_on_association(:user).macro).to eq :belongs_to
      end
    end
    context 'Genreモデルとの関係' do
      it 'N:1となっている' do
        expect(PostBook.reflect_on_association(:genre).macro).to eq :belongs_to
      end
    end
    context 'Commentモデルとの関係' do
      it '1:Nとなっている' do
        expect(PostBook.reflect_on_association(:comments).macro).to eq :has_many
      end
    end
    context 'Favoriteモデルとの関係' do
      it '1:Nとなっている' do
        expect(PostBook.reflect_on_association(:favorites).macro).to eq :has_many
      end
    end
    context 'Notificationモデルとの関係' do
      it '1:Nとなっている' do
        expect(PostBook.reflect_on_association(:notifications).macro).to eq :has_many
      end
    end
  end
end