# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Userモデルのテスト', type: :model do
  describe '実際に保存してみる' do
    it '有効な投稿の場合は保存されるか' do
      expect(FactoryBot.build(:user)).to be_valid
    end
  end

  describe 'バリデーションのテスト' do
    let!(:other_user) { create(:user) }
    let(:user) { build(:user) }

    context 'nicknameカラム' do
      it '空欄の場合にバリデーションチェックされているか' do
        user.nickname = ''
        expect(user).to be_invalid
      end
      it '2文字以上であること: 1文字は×' do
        user.nickname = Faker::Lorem.characters(number: 1)
        expect(user).to be_invalid
      end
      it '2文字以上であること: 2文字は◎' do
        user.nickname = Faker::Lorem.characters(number: 2)
        expect(user).to be_valid
      end
      it '10文字以内であること: 11文字は×' do
        user.nickname = Faker::Lorem.characters(number: 11)
        expect(user).to be_invalid
      end
      it '10文字以内であること: 10文字は◎' do
        user.nickname = Faker::Lorem.characters(number: 10)
        expect(user).to be_valid
      end
      it '一意性であること' do
        user.nickname = other_user.nickname
        expect(user).to be_invalid
      end
    end


    context '自己紹介カラム' do
      it '400文字以内であること: 401文字は×' do
        user.introduction = Faker::Lorem.characters(number: 401)
        expect(user).to be_invalid
      end
      it '400文字以内であること: 400文字は◎' do
        user.introduction = Faker::Lorem.characters(number: 400)
        expect(user).to be_valid
      end
    end
  end

  describe 'アソシエーションのテスト' do
    context 'Bookモデルとの関係' do
      it '1:Nとなっている' do
        expect(User.reflect_on_association(:books).macro).to eq :has_many
      end
    end
    context 'PostBookモデルとの関係' do
      it '1:Nとなっている' do
        expect(User.reflect_on_association(:post_books).macro).to eq :has_many
      end
    end
    context 'Commentモデルとの関係' do
      it '1:Nとなっている' do
        expect(User.reflect_on_association(:comments).macro).to eq :has_many
      end
    end
    context 'Favoriteモデルとの関係' do
      it '1:Nとなっている' do
        expect(User.reflect_on_association(:favorites).macro).to eq :has_many
      end
    end
  end
end
