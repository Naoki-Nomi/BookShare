# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Bookモデルのテスト', type: :model do
  describe '実際に保存してみる' do
    it '有効な投稿の場合は保存されるか' do
      expect(FactoryBot.build(:book)).to be_valid
    end
  end

  describe 'バリデーションのテスト' do
    let(:user) { create(:user) }
    let(:genre) { create(:genre) }
    let!(:book) { build(:book, user_id: user.id, genre_id: genre.id) }

    context 'authorカラム' do
      it '空欄の場合にバリデーションチェックされているか' do
        book.author = ''
        expect(book).to be_invalid
      end
      it '30文字以内であること: 31文字は×' do
        book.author = Faker::Lorem.characters(number: 31)
        expect(book).to be_invalid
      end
      it '30文字以内であること: 30文字は◎' do
        book.author = Faker::Lorem.characters(number: 30)
        expect(book).to be_valid
      end
    end

    context 'book_titleカラム' do
      it '空欄の場合にバリデーションチェックされているか' do
        book.book_title = ''
        expect(book).to be_invalid
      end
      it '30文字以内であること: 31文字は×' do
        book.book_title = Faker::Lorem.characters(number: 31)
        expect(book).to be_invalid
      end
      it '30文字以内であること: 30文字は◎' do
        book.book_title = Faker::Lorem.characters(number: 30)
        expect(book).to be_valid
      end
    end

    context 'noteカラム' do
      it '1200文字以内であること: 1201文字は×' do
        book.note = Faker::Lorem.characters(number: 1201)
        expect(book).to be_invalid
      end
      it '1200文字以内であること: 1200文字は◎' do
        book.note = Faker::Lorem.characters(number: 1200)
        expect(book).to be_valid
      end
    end

    context 'read_dateカラム' do
      it '空欄の場合にバリデーションチェックされているか' do
        book.read_date = ''
        expect(book).to be_invalid
      end
    end
  end

  describe 'アソシエーションのテスト' do
    context 'Userモデルとの関係' do
      it 'N:1となっている' do
        expect(Book.reflect_on_association(:user).macro).to eq :belongs_to
      end
    end

    context 'Genreモデルとの関係' do
      it 'N:1となっている' do
        expect(Book.reflect_on_association(:genre).macro).to eq :belongs_to
      end
    end
  end
end
