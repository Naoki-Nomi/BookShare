# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Genreモデルのテスト', type: :model do
  describe '実際に保存してみる' do
    it '有効な投稿の場合は保存されるか' do
      expect(FactoryBot.build(:genre)).to be_valid
    end
  end

  describe 'バリデーションのテスト' do
    let(:genre) { build(:genre) }

    it 'namaカラムが空欄の場合にバリデーションチェックされているか' do
      genre.name = ''
      expect(genre).to be_invalid
    end
  end

  describe 'アソシエーションのテスト' do
    context 'Bookモデルとの関係' do
      it '1:Nとなっている' do
        expect(Genre.reflect_on_association(:books).macro).to eq :has_many
      end
    end

    context 'PostBookモデルとの関係' do
      it '1:Nとなっている' do
        expect(Genre.reflect_on_association(:post_books).macro).to eq :has_many
      end
    end
  end
end
