# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Contactモデルのテスト', type: :model do
  describe '実際に保存してみる' do
    it '有効な投稿の場合は保存されるか' do
      expect(FactoryBot.build(:contact)).to be_valid
    end
  end

  describe 'バリデーションのテスト' do
    let(:contact) { build(:contact) }

    context 'nameカラム' do
      it '空欄の場合にバリデーションチェックされているか' do
        contact.name = ''
        expect(contact).to be_invalid
      end
      it '30文字以内であること: 31文字は×' do
        contact.name = Faker::Lorem.characters(number: 31)
        expect(contact).to be_invalid
      end
      it '30文字以内であること: 30文字は◎' do
        contact.name = Faker::Lorem.characters(number: 30)
        expect(contact).to be_valid
      end
    end

    context 'emailカラム' do
      it '空欄の場合にバリデーションチェックされているか' do
        contact.email = ''
        expect(contact).to be_invalid
      end
    end

    context 'contentカラム' do
      it '空欄の場合にバリデーションチェックされているか' do
        contact.content = ''
        expect(contact).to be_invalid
      end
      it '400文字以内であること: 401文字は×' do
        contact.content = Faker::Lorem.characters(number: 401)
        expect(contact).to be_invalid
      end
      it '30文字以内であること: 400文字は◎' do
        contact.content = Faker::Lorem.characters(number: 400)
        expect(contact).to be_valid
      end
    end
  end
end
