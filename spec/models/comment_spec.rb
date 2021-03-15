# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Commentモデルのテスト', type: :model do
  describe '実際に保存してみる' do
    it '有効な投稿の場合は保存されるか' do
      expect(FactoryBot.build(:comment)).to be_valid
    end
  end

  describe 'バリデーションのテスト' do
    let(:user) { create(:user) }
    let(:post_book) { create(:post_book) }
    let!(:comment) { build(:comment, user_id: user.id, post_book_id: post_book.id) }

    context 'comment_contentカラム' do
      it '空欄の場合にバリデーションチェックされているか' do
        comment.comment_content = ''
        expect(comment).to be_invalid
      end
      it '400文字以内であること: 401文字は×' do
        comment.comment_content = Faker::Lorem.characters(number: 401)
        expect(comment).to be_invalid
      end
      it '30文字以内であること: 30文字は◎' do
        comment.comment_content = Faker::Lorem.characters(number: 400)
        expect(comment).to be_valid
      end
    end
  end

  describe 'アソシエーションのテスト' do
    context 'Userモデルとの関係' do
      it 'N:1となっている' do
        expect(Comment.reflect_on_association(:user).macro).to eq :belongs_to
      end
    end
    context 'PostBookモデルとの関係' do
      it 'N:1となっている' do
        expect(Comment.reflect_on_association(:post_book).macro).to eq :belongs_to
      end
    end
    context 'Notificationモデルとの関係' do
      it '1:Nとなっている' do
        expect(Comment.reflect_on_association(:notifications).macro).to eq :has_many
      end
    end
  end
end