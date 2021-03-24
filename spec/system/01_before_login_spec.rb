# frozen_string_literal: true

require 'rails_helper'

describe '[STEP1] ユーザーログイン前のテスト' do
  describe 'トップ画面のテスト' do
    before do
      visit root_path
    end

    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/'
      end
      it 'ロゴのリンクが表示されているか' do
        expect(page).to have_link "", href: root_path
      end
      it '新規登録のリンクが表示されているか' do
        expect(page).to have_link "", href: new_user_registration_path
      end
      it 'ログインのリンクが表示されているか' do
        expect(page).to have_link "", href: new_user_session_path
      end
      it 'BookShareとは？の記載があるか' do
        expect(page).to have_content "BookShareとは？"
      end
      it 'BookShareのメリットの記載があるか' do
        expect(page).to have_content "BookShareのメリット"
      end
      it 'BookShareの使い方の記載があるか' do
        expect(page).to have_content "BookShareの使い方"
      end
    end
  end

  describe 'ヘッダーのテスト: ログインしていない場合' do
    before do
      visit root_path
    end

    context '表示内容の確認' do
      it 'タイトルが表示されるか' do
        expect(page).to have_content 'BookShare'
      end
      it 'URLが正しい' do
        expect(current_path).to eq '/'
      end
      it 'ロゴのリンクが表示されているか' do
        expect(page).to have_link "", href: root_path
      end
      it '新規登録のリンクが表示されているか' do
        expect(page).to have_link "", href: new_user_registration_path
      end
      it 'ログインのリンクが表示されているか' do
        expect(page).to have_link "", href: new_user_session_path
      end
    end

    context 'リンク内容を確認' do
      subject { current_path }

      it '新規登録を押すと、新規登録画面に遷移する' do
        signup_link = find_all('a')[1].native.inner_text
        signup_link = signup_link.gsub(/\n/, '').gsub(/\A\s*/, '').gsub(/\s*\Z/, '')
        click_link signup_link, match: :first
        is_expected.to eq '/users/sign_up'
      end
      it 'ログインを押すと、ログイン画面に遷移する' do
        login_link = find_all('a')[2].native.inner_text
        login_link = login_link.gsub(/\n/, '').gsub(/\A\s*/, '').gsub(/\s*\Z/, '')
        click_link login_link, match: :first
        is_expected.to eq '/users/sign_in'
      end
    end
  end

  describe 'ユーザー新規登録のテスト' do
    before do
      visit new_user_registration_path
    end

    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/users/sign_up'
      end
      it '新規登録と表示される' do
        expect(page).to have_content "新規登録"
      end
      it 'nicknameフォームが表示される' do
        expect(page).to have_field 'user[nickname]'
      end
      it 'emailフォームが表示される' do
        expect(page).to have_field 'user[email]'
      end
      it 'passwordフォームが表示される' do
        expect(page).to have_field 'user[password]'
      end
      it 'password_confirmationフォームが表示される' do
        expect(page).to have_field 'user[password_confirmation]'
      end
      it '新規登録ボタンが表示される' do
        expect(page).to have_button '新規登録'
      end
    end

    context '新規登録のテスト' do
      before do
        fill_in 'user[nickname]', with: Faker::Lorem.characters(number: 10)
        fill_in 'user[email]', with: Faker::Internet.email
        fill_in 'user[password]', with: 'password'
        fill_in 'user[password_confirmation]', with: 'password'
      end

      it '正しく登録される' do
        expect { click_button '新規登録' }.to change(User.all, :count).by(1)
      end
      it '新規登録後のリダイレクト先が、新規登録でできたユーザの詳細画面になっている' do
        click_button '新規登録'
        expect(current_path).to eq '/users/' + User.last.id.to_s
      end
    end
  end

  describe 'ユーザーログインのテスト' do
    let(:user) { create(:user) }

    before do
      visit new_user_session_path
    end

    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/users/sign_in'
      end
      it 'ログインと表示される' do
        expect(page).to have_content "ログイン"
      end
      it 'emailフォームが表示される' do
        expect(page).to have_field 'user[email]'
      end
      it 'passwordフォームが表示される' do
        expect(page).to have_field 'user[password]'
      end
      it 'ログインボタンが表示される' do
        expect(page).to have_button 'ログイン'
      end
    end

    context 'ログイン成功のテスト' do
      before do
        fill_in 'user[email]', with: user.email
        fill_in 'user[password]', with: user.password
        click_button 'ログイン'
      end

      it 'ログイン後のリダイレクト先が、ログインしたユーザの詳細画面になっている' do
        expect(current_path).to eq '/users/' + user.id.to_s
      end
    end

    context 'ログイン失敗のテスト' do
      before do
        fill_in 'user[email]', with: ''
        fill_in 'user[password]', with: ''
        click_button 'ログイン'
      end

      it 'ログインに失敗し、ログイン画面にリダイレクトされる' do
        expect(current_path).to eq '/users/sign_in'
      end
      it 'エラーメッセージが表示されている' do
        expect(page).to have_content "を入力してください"
      end
    end
  end

  describe 'ヘッダーのテスト' do
    let(:user) { create(:user) }

    before do
      visit new_user_session_path
      fill_in 'user[email]', with: user.email
      fill_in 'user[password]', with: user.password
      click_button 'ログイン'
    end

    context 'ヘッダーの内容確認' do
      it 'タイトルが表示されるか' do
        expect(page).to have_content 'BookShare'
      end
      it 'マイページのリンクが表示されているか' do
        expect(page).to have_link "", href: user_path(user)
      end
      it '新規投稿のリンクが表示されているか' do
        expect(page).to have_link "", href: new_post_book_path
      end
      it '投稿一覧のリンクが表示されているか' do
        expect(page).to have_link "", href: post_books_path
      end
      it '読書記録のリンクが表示されているか' do
        expect(page).to have_link "", href: new_book_path
      end
      it '読書一覧のリンクが表示されているか' do
        expect(page).to have_link "", href: books_path(user_id: user)
      end
      it 'ログアウトのリンクが表示されているか' do
        expect(page).to have_link "", href: destroy_user_session_path
      end
    end

    context 'リンク内容を確認' do
      subject { current_path }

      it 'マイページを押すと、マイページ画面に遷移する' do
        mypage_link = find_all('a')[1].native.inner_text
        mypage_link = mypage_link.gsub(/\n/, '').gsub(/\A\s*/, '').gsub(/\s*\Z/, '')
        click_link mypage_link
        is_expected.to eq '/users/' + user.id.to_s
      end
      it '新規投稿を押すと、新規投稿画面に遷移する' do
        newpost_link = find_all('a')[2].native.inner_text
        newpost_link = newpost_link.gsub(/\n/, '').gsub(/\A\s*/, '').gsub(/\s*\Z/, '')
        click_link newpost_link
        is_expected.to eq '/post_books/new'
      end
      it '投稿一覧を押すと、投稿一覧画面に遷移する' do
        indexpost = find_all('a')[3].native.inner_text
        indexpost = indexpost.gsub(/\n/, '').gsub(/\A\s*/, '').gsub(/\s*\Z/, '')
        click_link indexpost
        is_expected.to eq '/post_books'
      end
      it '読書記録を押すと、読書記録登録画面に遷移する' do
        newbook_link = find_all('a')[4].native.inner_text
        newbook_link = newbook_link.gsub(/\n/, '').gsub(/\A\s*/, '').gsub(/\s*\Z/, '')
        click_link newbook_link
        is_expected.to eq '/books/new'
      end
      it '読書一覧を押すと、読書一覧画面に遷移する' do
        indexbook_link = find_all('a')[5].native.inner_text
        indexbook_link = indexbook_link.gsub(/\n/, '').gsub(/\A\s*/, '').gsub(/\s*\Z/, '')
        click_link indexbook_link
        is_expected.to eq "/books"
      end
      it 'ログアウトを押すと、トップページに遷移する' do
        logout_link = find_all('a')[6].native.inner_text
        logout_link = logout_link.gsub(/\n/, '').gsub(/\A\s*/, '').gsub(/\s*\Z/, '')
        click_link logout_link
        is_expected.to eq '/'
      end
    end
  end

  describe 'ユーザーログアウトのテスト' do
    let(:user) { create(:user) }

    before do
      visit new_user_session_path
      fill_in 'user[email]', with: user.email
      fill_in 'user[password]', with: user.password
      click_button 'ログイン'
      logout_link = find_all('a')[6].native.inner_text
      logout_link = logout_link.gsub(/\n/, '').gsub(/\A\s*/, '').gsub(/\s*\Z/, '')
      click_link logout_link
    end

    context 'ログアウト機能のテスト' do
      it '正しくログアウトできている: ログアウト後のリダイレクト先おいて新規登録リンクが存在する' do
        expect(page).to have_link '', href: '/users/sign_up'
      end
      it 'ログアウト後のリダイレクト先がトップページになっている' do
        expect(current_path).to eq '/'
      end
    end
  end
end
