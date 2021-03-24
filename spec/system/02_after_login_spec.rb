# frozen_string_literal: true

require 'rails_helper'

describe '[STEP2] ユーザログイン後のテスト' do
  let!(:user) { create(:user) }
  let!(:other_user) { create(:user) }
  let!(:genre) { create(:genre) }
  let!(:other_genre) { create(:genre) }
  let!(:book) { create(:book, user: user, genre: genre) }
  let!(:other_book) { create(:book, user: other_user, genre: genre) }
  let!(:post_book) { create(:post_book, user: user,  genre: genre) }
  let!(:other_post_book) { create(:post_book, user: other_user, genre: genre) }


  before do
    visit new_user_session_path
    fill_in 'user[email]', with: user.email
    fill_in 'user[password]', with: user.password
    click_button 'ログイン'
  end

  describe 'マイページのテスト' do
    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq "/users/#{user.id}"
      end
      it 'ページタイトルがあるか' do
        expect(page).to have_content "#{user.nickname}さんのページ"
      end
      it 'フォロー一覧のリンクがあるか' do
        expect(page).to have_link "", href: relationships_path(id: user, relationship_order: 0)
      end
      it 'フォロワー一覧のリンクがあるか' do
        expect(page).to have_link "", href: relationships_path(id: user, relationship_order: 1)
      end
      it '自分の投稿一覧へのリンクがあるか' do
        expect(page).to have_link "", href: post_books_path(user_id: user, book_sort: 0)
      end
      it '自分の登録書籍へのリンクがあるか' do
        expect(page).to have_link "", href: books_path(user_id: user)
      end
      it '自分がいいねした投稿一覧へのリンクがあるか' do
        expect(page).to have_link "", href: favorites_path(user_id: user)
      end
      it 'プロフィール編集へのリンクがあるか' do
        expect(page).to have_link "", href: edit_user_path(user)
      end
      it '通知へのリンクがあるか' do
        expect(page).to have_link "", href: notifications_path
      end
      it '退会へのリンクがあるか' do
        expect(page).to have_link "", href: user_confirm_path(user)
      end
    end

    context 'リンク内容を確認' do
      subject { current_path }

      it '7番目のリンクをクリックすると、フォロー一覧に遷移する' do
        link = find_all('a')[7]
        link.click
        is_expected.to eq '/relationships'
      end
      it '8番目のリンクをクリックすると、フォロワー一覧に遷移する' do
        link = find_all('a')[8]
        link.click
        is_expected.to eq '/relationships'
      end
      it '9番目のリンクをクリックすると、いいねした投稿一覧に遷移する' do
        link = find_all('a')[9]
        link.click
        is_expected.to eq '/favorites'
      end
      it '10番目のリンクをクリックすると、自分の投稿一覧に遷移する' do
        link = find_all('a')[10]
        link.click
        is_expected.to eq '/post_books'
      end
      it '11番目のリンクをクリックすると、自分の読書記録一覧に遷移する' do
        link = find_all('a')[11]
        link.click
        is_expected.to eq "/books"
      end
      it '17番目のリンクをクリックすると、ユーザー編集画面に遷移する' do
        link = find_all('a')[17]
        link.click
        is_expected.to eq "/users/#{user.id}/edit"
      end
      it '18番目のリンクをクリックすると、自分の投稿一覧に遷移する' do
        link = find_all('a')[18]
        link.click
        is_expected.to eq '/post_books'
      end
      it '19番目のリンクをクリックすると、自分の読書記録一覧に遷移する' do
        link = find_all('a')[19]
        link.click
        is_expected.to eq "/books"
      end
      it '20番目のリンクをクリックすると、通知一覧に遷移する' do
        link = find_all('a')[20]
        link.click
        is_expected.to eq '/notifications'
      end
      it '21番目のリンクをクリックすると、退会確認画面に遷移する' do
        link = find_all('a')[21]
        link.click
        is_expected.to eq "/users/page/#{user.id}/confirm"
      end
    end
  end

  describe 'プロフィール編集機能のテスト' do
    before do
        link = find_all('a')[17]
        link.click
    end

    context 'プロフィール編集フォームの確認' do
      it 'URLの確認' do
        expect(current_path).to eq "/users/#{user.id}/edit"
      end
      it '表示内容の確認' do
        expect(page).to have_content "プロフィール編集"
      end
      it '編集前のニックネームが設定されているか' do
        expect(page).to have_field 'user[nickname]', with: user.nickname
      end
      it '編集前のemailが設定されているか' do
        expect(page).to have_field 'user[email]', with: user.email
      end
      it '自己紹介のフォームがあるか' do
        expect(page).to have_field 'user[introduction]'
      end
      it '画像編集フォームがあるか' do
        expect(page).to have_field 'user[profile_image]'
      end
      it '編集内容を保存するボタンが表示される' do
        expect(page).to have_button '編集内容を保存'
      end
    end

    context 'プロフィール編集のテスト' do
      before do
        @user_old_nickname = user.nickname
        @user_old_email = user.email
        fill_in 'user[nickname]', with: Faker::Lorem.characters(number: 10)
        fill_in 'user[email]', with: Faker::Internet.email
        fill_in 'user[introduction]', with: Faker::Lorem.characters(number: 50)
        click_button '編集内容を保存'
      end

      it 'ニックネームが正しく更新されている' do
        expect(user.reload.nickname).to_not eq @user_old_nickname
      end
      it 'メールアドレスが正しく更新されている' do
        expect(user.reload.email).to_not eq @user_old_email
      end
      it '自己紹介が正しく更新されている' do
        expect(user.reload.introduction).to_not eq nil
      end
      it 'リダイレクト先が、自分の詳細画面になっている' do
        expect(current_path).to eq "/users/#{user.id}"
      end
    end
  end

  describe '退会機能のテスト' do
    before do
      link = find_all('a')[21]
      link.click
    end

    context '退会確認画面の確認' do
      it 'URLの確認' do
        expect(current_path).to eq "/users/page/#{user.id}/confirm"
      end
      it '戻るボタンが表示されている' do
        expect(page).to have_link '戻る'
      end
      it '退会するボタンが表示されている' do
        expect(page).to have_link '退会する'
      end
    end

    context '退会機能の確認' do
      before do
        click_on '退会する'
      end

      it 'リダイレクト先がトップページに遷移しているか' do
        expect(current_path).to eq '/'
      end
      it 'ヘッダーに新規会員登録が表示されている' do
        signup_link = find_all('a')[1].native.inner_text
        signup_link = signup_link.gsub(/\n/, '').gsub(/\A\s*/, '').gsub(/\s*\Z/, '')
        expect(signup_link).to eq '新規登録'
      end
      it 'ヘッダーにログインが表示されている' do
        login_link = find_all('a')[2].native.inner_text
        login_link = login_link.gsub(/\n/, '').gsub(/\A\s*/, '').gsub(/\s*\Z/, '')
        expect(login_link).to eq 'ログイン'
      end
      it '再度ログインすることができず、エラーメッセージが表示される' do
        login_link = find_all('a')[2]
        login_link.click
        fill_in 'user[email]', with: user.email
        fill_in 'user[password]', with: user.password
        click_button 'ログイン'
        expect(current_path).to eq '/users/sign_in'
        expect(page).to have_content "退会済みです"
      end
    end
  end

  describe '新規投稿のテスト' do
    before do
      click_link "新規投稿"
    end

    context "新規投稿フォームの確認" do
      it 'urlの確認' do
        expect(current_path).to eq '/post_books/new'
      end
      it 'フォームの確認：著者' do
        expect(page).to have_field 'post_book[post_book_author]'
      end
      it 'フォームの確認：題名' do
        expect(page).to have_field 'post_book[post_book_title]'
      end
      it 'フォームの確認：ジャンル' do
        expect(page).to have_field 'post_book[genre_id]'
      end
      it 'フォームの確認：投稿タイトル' do
        expect(page).to have_field 'post_book[title]'
      end
      it 'フォームの確認：投稿内容' do
        expect(page).to have_field 'post_book[content]'
      end
      it 'フォームの確認：投稿するボタン' do
        expect(page).to have_button '投稿'
      end
    end

    context "新規投稿機能(成功)のテスト" do
      before do
        fill_in 'post_book[post_book_author]', with: Faker::Lorem.characters(number: 5)
        fill_in 'post_book[post_book_title]', with: Faker::Lorem.characters(number: 10)
        fill_in 'post_book[title]', with: Faker::Lorem.characters(number: 15)
        fill_in 'post_book[content]', with: Faker::Lorem.characters(number: 300)
        find("option[value='1']").select_option
      end

      it 'urlの確認' do
        expect(current_path).to eq '/post_books/new'
      end
      it '自分の投稿が正しく保存されている' do
        expect { click_button '投稿' }.to change(user.post_books, :count).by(1)
      end
      it '投稿後、一覧画面にリダイレクトされる' do
        click_button '投稿'
        expect(current_path).to eq '/post_books'
      end
    end

    context "新規投稿機能(失敗)のテスト" do
      before do
        fill_in 'post_book[post_book_author]', with: ''
        fill_in 'post_book[post_book_title]', with: ''
        fill_in 'post_book[title]', with: ''
        fill_in 'post_book[content]', with: ''
        click_button '投稿'
      end

      it '著者名を入力してくださいのエラーが表示される' do
        expect(page).to have_content '著者名を入力してください'
      end
      it '本の題名を入力してくださいのエラーが表示される' do
        expect(page).to have_content '本の題名を入力してください'
      end
      it 'タイトルを入力してくださいのエラーが表示される' do
        expect(page).to have_content 'タイトルを入力してください'
      end
      it '投稿内容を入力してくださいのエラーが表示される' do
        expect(page).to have_content '投稿内容を入力してください'
      end
      it 'ジャンル名を入力してくださいのエラーが表示される' do
        expect(page).to have_content 'ジャンル名を入力してください'
      end
    end
  end

  describe '投稿一覧画面のテスト' do
    before do
      visit post_books_path
    end

    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/post_books'
      end
      it '自分と他人のユーザー画像のリンク先が正しい' do
        expect(page).to have_link '', href: user_path(post_book.user)
        expect(page).to have_link '', href: user_path(other_post_book.user)
      end
      it '自分と他人の投稿のリンク先が正しい' do
        expect(page).to have_link '', href: post_book_path(post_book)
        expect(page).to have_link '', href: user_path(other_post_book)
      end
      it '自分と他人のユーザーニックネームが表示されている' do
        expect(page).to have_content post_book.user.nickname
        expect(page).to have_content other_post_book.user.nickname
      end
      it '自分と他人の投稿のタイトルが表示されている' do
        expect(page).to have_content post_book.title
        expect(page).to have_content other_post_book.title
      end
      it '自分と他人の投稿ジャンルが表示されている' do
        expect(page).to have_content post_book.genre.name
        expect(page).to have_content other_post_book.genre.name
      end
      it '自分と他人の投稿コメント数が表示されている' do
        expect(page).to have_content post_book.comments.count
        expect(page).to have_content other_post_book.comments.count
      end
      it '自分と他人の投稿にいいね数が表示されている' do
        expect(page).to have_content post_book.favorites.count
        expect(page).to have_content other_post_book.favorites.count
      end
    end

    describe '検索のテスト' do
      let!(:post_book) { create(:post_book, post_book_author: "夏目漱石", post_book_title: "こころ", genre_id: 1, title: "大人になれなかった先生", content: "面白いです", user_id: 1) }

      context '検索フォームの確認' do
        it 'フォームの確認：検索ワード' do
          expect(page).to have_field 'search'
        end
        it 'フォームの確認：ジャンル' do
          expect(page).to have_field 'genre_id'
        end
        it 'フォームの確認：日付' do
          expect(page).to have_field 'post_from'
        end
        it 'フォームの確認：日付' do
          expect(page).to have_field 'post_to'
        end
        it '検索ボタンが表示されているか' do
          expect(page).to have_button '検索'
        end
      end

      context '検索結果の確認（見つかる場合）' do
        it '著者名で検索' do
          fill_in 'search', with: '夏目'
          click_button '検索'
          expect(page).to have_content '夏目漱石'
          expect(current_path).to eq "/post_books/search"
        end
        it '本のタイトルで検索' do
          fill_in 'search', with: 'ここ'
          click_button '検索'
          expect(page).to have_content '夏目漱石'
          expect(current_path).to eq "/post_books/search"
        end
        it '投稿タイトルで検索' do
          fill_in 'search', with: '大人'
          click_button '検索'
          expect(page).to have_content '夏目漱石'
          expect(current_path).to eq "/post_books/search"
        end
        it 'ジャンルで検索' do
          find("option[value='1']").select_option
          click_button '検索'
          expect(page).to have_content '夏目漱石'
          expect(current_path).to eq "/post_books/search"
        end
        it '日付で検索' do
          fill_in 'post_from', with: '2020-01-01'
          fill_in 'post_to', with: '2021-12-31'
          click_button '検索'
          expect(page).to have_content '夏目漱石'
          expect(current_path).to eq "/post_books/search"
        end
      end

      context '検索結果の確認（見つからない場合）' do
        it '著者名で検索' do
          fill_in 'search', with: '芥川'
          click_button '検索'
          expect(page).to have_content '該当するデータはありません'
          expect(current_path).to eq "/post_books/search"
        end
        it '本のタイトルで検索' do
          fill_in 'search', with: '人間失格'
          click_button '検索'
          expect(page).to have_content '該当するデータはありません'
          expect(current_path).to eq "/post_books/search"
        end
        it '投稿タイトルで検索' do
          fill_in 'search', with: '純粋性'
          click_button '検索'
          expect(page).to have_content '該当するデータはありません'
          expect(current_path).to eq "/post_books/search"
        end
        it 'ジャンルで検索' do
          find("option[value='2']").select_option
          click_button '検索'
          expect(page).to have_content '該当するデータはありません'
          expect(current_path).to eq "/post_books/search"
        end
        it '日付で検索' do
          fill_in 'post_from', with: '2020-01-01'
          fill_in 'post_to', with: '2020-12-31'
          click_button '検索'
          expect(page).to have_content '該当するデータはありません'
          expect(current_path).to eq "/post_books/search"
        end
      end
    end
  end

  describe '投稿詳細画面のテスト' do
    before do
      visit post_book_path(post_book)
    end

    it 'リンクの確認' do
      expect(current_path).to eq "/post_books/#{post_book.id}"
    end
    it '著者名が表示されているか' do
      expect(page).to have_content post_book.post_book_author
    end
    it '題名が表示されているか' do
      expect(page).to have_content post_book.post_book_title
    end
    it 'ユーザーニックネームが表示されているか' do
      expect(page).to have_content post_book.user.nickname
    end
    it '投稿タイトルが表示されているか' do
      expect(page).to have_content post_book.title
    end
    it '投稿内容が表示されているか' do
      expect(page).to have_content post_book.content
    end
    it '投稿日が表示されているか' do
      expect(page).to have_content post_book.created_at.strftime('%Y/%m/%d')
    end
    it '投稿のジャンル名が表示されているか' do
      expect(page).to have_content post_book.genre.name
    end
    it 'コメント数が表示されているか' do
      expect(page).to have_content post_book.comments.count
    end
    it 'いいね数が表示されているか' do
      expect(page).to have_content post_book.favorites.count
    end
    it '編集リンクが表示されているか' do
      expect(page).to have_link '編集する', href: edit_post_book_path(post_book)
    end
    it '削除リンクが表示されているか' do
      expect(page).to have_link '削除する', href: post_book_path(post_book)
    end
    it 'いいねリンクが表示されてるか' do
      expect(page).to have_link 'いいねする', href: post_book_favorites_path(post_book)
    end
    it 'コメントを投稿するフィールドが表示されている' do
      expect(page).to have_field 'comment[comment_content]'
    end
    it 'コメントを投稿するボタンが表示されている' do
      expect(page).to have_button 'コメントを投稿する'
    end

    describe '編集機能のテスト' do
      before do
        edit_link = find_all('a')[7]
        edit_link.click
      end

      context '編集画面の確認' do
        it 'リンク先の確認' do
          expect(current_path).to eq "/post_books/#{post_book.id}/edit"
        end
        it 'フォームの確認：著者に値が設定されているか' do
          expect(page).to have_field 'post_book[post_book_author]', with: post_book.post_book_author
        end
        it 'フォームの確認：題名に値が設定されているか' do
          expect(page).to have_field 'post_book[post_book_title]', with: post_book.post_book_title
        end
        it 'ジャンルに値が設定されているか' do
          expect(page).to have_content post_book.genre.name
        end
        it 'フォームの確認：投稿タイトルに値が設定されているか' do
          expect(page).to have_field 'post_book[title]', with: post_book.title
        end
        it 'フォームの確認：投稿内容に値が設定されているか' do
          expect(page).to have_field 'post_book[content]', with: post_book.content
        end
        it 'フォームの確認：投稿するボタン' do
          expect(page).to have_button '編集内容を保存'
        end
      end

      context '編集（成功）のテスト' do
        before do
          @post_book_old_post_book_author = post_book.post_book_author
          @post_book_old_post_book_title = post_book.post_book_title
          @post_book_old_title = post_book.title
          @post_book_old_content = post_book.content
          @post_book_old_genre = post_book.genre.name
          fill_in 'post_book[post_book_author]', with: Faker::Lorem.characters(number: 5)
          fill_in 'post_book[post_book_title]', with: Faker::Lorem.characters(number: 10)
          fill_in 'post_book[title]', with: Faker::Lorem.characters(number: 15)
          fill_in 'post_book[content]', with: Faker::Lorem.characters(number: 300)
          find("option[value='2']").select_option
          click_button '編集内容を保存'
        end

        it 'リンク先の確認' do
          expect(current_path).to eq "/post_books/#{post_book.id}"
        end
        it '著者名が更新されているか' do
          expect(post_book.reload.post_book_author).not_to eq @post_book_old_post_book_author
        end
        it '題名が更新されているか' do
          expect(post_book.reload.post_book_title).not_to eq @post_book_old_post_book_title
        end
        it '投稿タイトルが更新されているか' do
          expect(post_book.reload.title).not_to eq @post_book_old_title
        end
        it '投稿内容が更新されているか' do
          expect(post_book.reload.content).not_to eq @post_book_old_content
        end
        it 'ジャンル名が更新されているか' do
          expect(post_book.reload.genre.name).not_to eq @post_book_old_genre
        end
      end

      context '編集（失敗）のテスト' do
        before do
          fill_in 'post_book[post_book_author]', with: ''
          fill_in 'post_book[post_book_title]', with: ''
          fill_in 'post_book[title]', with: ''
          fill_in 'post_book[content]', with: ''
          click_button '編集内容を保存'
        end

        it '著者名を入力してくださいのエラーが表示される' do
          expect(page).to have_content '著者名を入力してください'
        end
        it '本の題名を入力してくださいのエラーが表示される' do
          expect(page).to have_content '本の題名を入力してください'
        end
        it 'タイトルを入力してくださいのエラーが表示される' do
          expect(page).to have_content 'タイトルを入力してください'
        end
        it '投稿内容を入力してくださいのエラーが表示される' do
          expect(page).to have_content '投稿内容を入力してください'
        end
      end
    end

    describe '削除機能のテスト' do
      before do
        delete_link = find_all('a')[8]
        delete_link.click
      end

      it '正しく削除される' do
        expect(PostBook.where(id: post_book.id).count).to eq 0
      end
      it 'リダイレクト先が投稿一覧画面になっている' do
        expect(current_path).to eq '/post_books'
      end
    end
  end

  describe '読書記録のテスト' do
    before do
      click_link "読書記録"
    end
    context "読書記録フォームの確認" do
      it 'urlの確認' do
        expect(current_path).to eq '/books/new'
      end
      it 'フォームの確認：著者' do
        expect(page).to have_field 'book[author]'
      end
      it 'フォームの確認：題名' do
        expect(page).to have_field 'book[book_title]'
      end
      it 'フォームの確認：ジャンル' do
        expect(page).to have_field 'book[genre_id]'
      end
      it 'フォームの確認：読み終わった日付' do
        expect(page).to have_field 'book[read_date]'
      end
      it 'フォームの確認：登録読書のメモ' do
        expect(page).to have_field 'book[note]'
      end
      it 'フォームの確認：投稿するボタン' do
        expect(page).to have_button '登録'
      end
    end

    context "読書記録機能(成功)のテスト" do
      before do
        fill_in 'book[author]', with: Faker::Lorem.characters(number: 5)
        fill_in 'book[book_title]', with: Faker::Lorem.characters(number: 10)
        fill_in 'book[note]', with: Faker::Lorem.characters(number: 200)
        fill_in 'book[read_date]', with: Faker::Date.between(from: '2020-10-01', to: '2021-02-28')
        find("option[value='1']").select_option
      end

      it '自分の投稿が正しく保存されている' do
        expect { click_button '登録' }.to change(user.books, :count).by(1)
      end
      it '投稿後、読書一覧画面にリダイレクトされる' do
        click_button '登録'
        expect(current_path).to eq "/books"
      end
    end

    context "読書記録機能(失敗)のテスト" do
      before do
        fill_in 'book[author]', with: ''
        fill_in 'book[book_title]', with: ''
        fill_in 'book[note]', with: ''
        fill_in 'book[read_date]', with: ''
        click_button '登録'
      end

      it '著者名を入力してくださいのエラーが表示される' do
        expect(page).to have_content '著者名を入力してください'
      end
      it '本の題名を入力してくださいのエラーが表示される' do
        expect(page).to have_content '本の題名を入力してください'
      end
      it 'タイトルを入力してくださいのエラーが表示される' do
        expect(page).to have_content '読み終わった日付を入力してください'
      end
      it 'ジャンル名を入力してくださいのエラーが表示される' do
        expect(page).to have_content 'ジャンル名を入力してください'
      end
    end
  end

  describe '読書一覧画面のテスト' do
    before do
      click_link '読書一覧'
    end

    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq "/books"
      end
      it '自分の登録した読書の著者名のみ表示されている' do
        expect(page).to have_content book.author
        expect(page).not_to have_content other_book.author
      end
      it '自分の登録した読書の題名のみ表示されている' do
        expect(page).to have_content book.book_title
        expect(page).not_to have_content other_book.book_title
      end
      it '自分の登録した読書の日付が表示されている' do
        expect(page).to have_content book.read_date
      end
      it '自分の登録した読書のジャンル名が表示されている' do
        expect(page).to have_content book.genre.name
      end
      it '読書詳細画面へのリンクが表示されている' do
        expect(page).to have_link '', href: book_path(book)
      end
    end

    describe '検索のテスト' do
      let!(:book) { create(:book, author: "夏目漱石", book_title: "こころ", genre_id: 1, note: "面白いです", read_date: "2021-02-01", user_id: 1) }

      context '検索フォームの確認' do
        it 'フォームの確認：検索ワード' do
          expect(page).to have_field 'search'
        end
        it 'フォームの確認：ジャンル' do
          expect(page).to have_field 'genre_id'
        end
        it 'フォームの確認：検索ワード' do
          expect(page).to have_field 'read_from'
        end
        it 'フォームの確認：検索ワード' do
          expect(page).to have_field 'read_to'
        end
        it '検索ボタンが表示されているか' do
          expect(page).to have_button '検索'
        end
      end

      context '検索結果の確認（見つかる場合）' do
        it '著者名で検索' do
          fill_in 'search', with: '夏目'
          click_button '検索'
          expect(page).to have_content '夏目漱石'
          expect(current_path).to eq "/books/search"
        end
        it '本のタイトルで検索' do
          fill_in 'search', with: 'ここ'
          click_button '検索'
          expect(page).to have_content '夏目漱石'
          expect(current_path).to eq "/books/search"
        end
        it 'ジャンルで検索' do
          find("option[value='1']").select_option
          click_button '検索'
          expect(page).to have_content '夏目漱石'
          expect(current_path).to eq "/books/search"
        end
        it '日付で検索' do
          fill_in 'read_from', with: '2021-01-01'
          fill_in 'read_to', with: '2021-02-28'
          click_button '検索'
          expect(page).to have_content '夏目漱石'
          expect(current_path).to eq "/books/search"
        end
      end

      context '検索結果の確認（見つからない場合）' do
        it '著者名で検索' do
          fill_in 'search', with: '芥川'
          click_button '検索'
          expect(page).to have_content '該当するデータはありません'
          expect(current_path).to eq "/books/search"
        end
        it '本のタイトルで検索' do
          fill_in 'search', with: '人間失格'
          click_button '検索'
          expect(page).to have_content '該当するデータはありません'
          expect(current_path).to eq "/books/search"
        end
        it 'ジャンルで検索' do
          find("option[value='2']").select_option
          click_button '検索'
          expect(page).to have_content '該当するデータはありません'
          expect(current_path).to eq "/books/search"
        end
        it '日付で検索' do
          fill_in 'read_from', with: '2020-01-01'
          fill_in 'read_to', with: '2020-12-31'
          click_button '検索'
          expect(page).to have_content '該当するデータはありません'
          expect(current_path).to eq "/books/search"
        end
      end
    end
  end

  describe '読書詳細画面のテスト' do
    before do
      visit book_path(book)
    end

    it 'リンクの確認' do
      expect(current_path).to eq "/books/#{book.id}"
    end
    it '著者名が表示されているか' do
      expect(page).to have_content book.author
    end
    it '題名が表示されているか' do
      expect(page).to have_content book.book_title
    end
    it 'ユーザーニックネームが表示されているか' do
      expect(page).to have_content book.user.nickname
    end
    it 'メモ内容が表示されているか' do
      expect(page).to have_content book.note
    end
    it '読み終わった日が表示されているか' do
      expect(page).to have_content book.read_date
    end
    it 'ジャンル名が表示されているか' do
      expect(page).to have_content book.genre.name
    end
    it '編集リンクが表示されているか' do
      expect(page).to have_link '編集する', href: edit_book_path(book)
    end
    it '削除リンクが表示されているか' do
      expect(page).to have_link '削除する', href: book_path(book)
    end

    describe '編集機能のテスト' do
      before do
        edit_link = find_all('a')[7]
        edit_link.click
      end

      context '編集画面の確認' do
        it 'リンク先の確認' do
          expect(current_path).to eq "/books/#{book.id}/edit"
        end
        it 'フォームの確認：著者に値が設定されているか' do
          expect(page).to have_field 'book[author]', with: book.author
        end
        it 'フォームの確認：題名に値が設定されているか' do
          expect(page).to have_field 'book[book_title]', with: book.book_title
        end
        it 'ジャンルに値が設定されているか' do
          expect(page).to have_content book.genre.name
        end
        it '読み終えた日に値が設定されているか' do
          expect(page).to have_field 'book[read_date]', with: book.read_date
        end
        it 'フォームの確認：読書メモに値が設定されているか' do
          expect(page).to have_field 'book[note]', with: book.note
        end
        it 'フォームの確認：編集内容を保存するボタン' do
          expect(page).to have_button '編集内容を保存'
        end
      end

      context '編集（成功）のテスト' do
        before do
          @book_old_author = book.author
          @book_old_book_title = book.book_title
          @book_old_note = book.note
          @book_old_read_date = book.read_date
          @book_old_genre = book.genre.name
          fill_in 'book[author]', with: Faker::Lorem.characters(number: 5)
          fill_in 'book[book_title]', with: Faker::Lorem.characters(number: 10)
          fill_in 'book[note]', with: Faker::Lorem.characters(number: 200)
          fill_in 'book[read_date]', with: Faker::Date.between(from: '2020-10-01', to: '2021-02-28')
          find("option[value='2']").select_option
          click_button '編集内容を保存'
        end

        it 'リンク先の確認' do
          expect(current_path).to eq "/books/#{book.id}"
        end
        it '著者名が更新されているか' do
          expect(book.reload.author).not_to eq @book_old_author
        end
        it '題名が更新されているか' do
          expect(book.reload.book_title).not_to eq @book_old_book_title
        end
        it '投稿タイトルが更新されているか' do
          expect(book.reload.note).not_to eq @book_old_note
        end
        it '投稿内容が更新されているか' do
          expect(book.reload.read_date).not_to eq @book_old_read_date
        end
        it 'ジャンル名が更新されているか' do
          expect(book.reload.genre.name).not_to eq @book_old_genre
        end
      end

      context '編集（失敗）のテスト' do
        before do
          fill_in 'book[author]', with: ''
          fill_in 'book[book_title]', with: ''
          fill_in 'book[read_date]', with: ''
          click_button '編集内容を保存'
        end

        it '著者名を入力してくださいのエラーが表示される' do
          expect(page).to have_content '著者名を入力してください'
        end
        it '本の題名を入力してくださいのエラーが表示される' do
          expect(page).to have_content '本の題名を入力してください'
        end
        it '読み終わった日付を入力してくださいのエラーが表示される' do
          expect(page).to have_content '読み終わった日付を入力してください'
        end
      end
    end

    describe '削除機能のテスト' do
      before do
        delete_link = find_all('a')[8]
        delete_link.click
      end

      it '正しく削除される' do
        expect(Book.where(id: book.id).count).to eq 0
      end
      it 'リダイレクト先が読書一覧画面になっている' do
        expect(current_path).to eq '/books'
      end
    end
  end

  describe '読書記録グラフ画面の確認' do
    before do
      visit detail_path(user_id: user)
    end

    it 'リンク先の確認' do
      expect(current_path).to eq "/books/#{user.id}/detail"
    end
    it '年間で表示のリンクがあるか' do
      expect(page).to have_link '年間で表示', href: detail_path(user_id: user, period: 1)
    end
    it '月間で表示のリンクがあるか' do
      expect(page).to have_link '月間で表示', href: detail_path(user_id: user)
    end
    it '週間で表示のリンクがあるか' do
      expect(page).to have_link '週間で表示', href: detail_path(user_id: user, period: 0)
    end
    it 'トップ5名を表示のリンクがあるか' do
      expect(page).to have_link 'トップ5名を表示', href: detail_path(user_id: user)
    end
    it 'トップ10名を表示のリンクがあるか' do
      expect(page).to have_link 'トップ10名を表示', href: detail_path(user_id: user, author_number: 0)
    end
    it '全ての著者を表示のリンクがあるか' do
      expect(page).to have_link '全ての著者を表示', href: detail_path(user_id: user, author_number: 1)
    end
    it '読書数を示すグラフがあるか' do
      expect(page).to have_selector "#amount_chart"
    end
    it '著者名を示すグラフがあるか' do
      expect(page).to have_selector "#author_chart"
    end
    it 'ジャンル名を示すグラフがあるか' do
      expect(page).to have_selector "#genre_chart"
    end
  end

  describe 'お問い合わせ機能の確認' do
    before do
      click_link 'お問い合わせ'
    end

    context 'お問い合わせ画面の確認' do
      it 'リンク先の確認' do
        expect(current_path).to eq '/contacts/new'
      end
      it 'フォームの確認：名前' do
        expect(page).to have_field 'contact[name]'
      end
      it 'フォームの確認：メールアドレス' do
        expect(page).to have_field 'contact[email]'
      end
      it 'フォームの確認：お問い合わせ内容' do
        expect(page).to have_field 'contact[content]'
      end
    end

    describe 'お問い合わせのテスト（成功）' do
      before do
        fill_in 'contact[name]', with: '田中太郎'
        fill_in 'contact[email]', with: 'tanaka@tarou'
        fill_in 'contact[content]', with: 'テスト内容'
        click_button 'ご入力内容を確認'
      end

      context 'お問い合わせ確認画面の確認' do
        it 'リンク先の確認' do
          expect(current_path).to eq '/contact/confirm'
        end
        it '名前に値が設定されているか' do
          expect(page).to have_content '田中太郎'
        end
        it 'メールアドレスに値が設定されているか' do
          expect(page).to have_content 'tanaka@tarou'
        end
        it 'お問い合わせ内容に値が設定されているか' do
          expect(page).to have_content 'テスト内容'
        end
        it '内容を確定するボタンが表示されているか' do
          expect(page).to have_link "内容を確定する"
        end
      end

      context 'お問い合わせ機能のテスト' do
        it 'お問い合わせ内容が正しく保存されている' do
          expect{ click_link "内容を確定する" }.to change{ Contact.count }.by(1)
        end
        it 'お問い合わせ投稿後、サンクス画面にリダイレクトされる' do
          click_link "内容を確定する"
          expect(current_path).to eq "/contact/thanks"
        end
      end
    end

    describe 'お問い合わせのテスト（失敗）' do
      before do
        fill_in 'contact[name]', with: ''
        fill_in 'contact[email]', with: ''
        fill_in 'contact[content]', with: ''
        click_button 'ご入力内容を確認'
      end

      it 'お名前を入力してくださいのエラーが表示されているか' do
        expect(page).to have_content "お名前を入力してください"
      end
      it 'メールアドレスを入力してくださいのエラーが表示されているか' do
        expect(page).to have_content "メールアドレスを入力してください"
      end
      it 'お問い合わせ内容を入力してくださいのエラーが表示されているか' do
        expect(page).to have_content "お問い合わせ内容を入力してください"
      end
    end
  end
end