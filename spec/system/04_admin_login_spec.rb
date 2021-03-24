# frozen_string_literal: true

require 'rails_helper'

describe '[STEP4] 管理者画面のテスト' do
  let!(:admin) { create(:admin) }
  let!(:user) { create(:user) }
  let!(:other_user) { create(:user) }
  let!(:genre) { create(:genre) }
  let!(:other_genre) { create(:genre) }
  let!(:book) { create(:book, user: user, genre: genre) }
  let!(:other_book) { create(:book, user: other_user, genre: genre) }
  let!(:post_book) { create(:post_book, user: user, genre: genre) }
  let!(:other_post_book) { create(:post_book, user: other_user, genre: genre) }

  before do
    visit new_admin_session_path
    fill_in 'admin[email]', with: admin.email
    fill_in 'admin[password]', with: admin.password
    click_button 'ログイン'
  end

  describe 'ヘッダーの確認' do
    it 'ジャンル一覧のリンクが表示されているか' do
      expect(page).to have_link "", href: admin_genres_path
    end
    it '会員一覧のリンクが表示されているか' do
      expect(page).to have_link "", href: admin_root_path
    end
    it '投稿一覧のリンクが表示されているか' do
      expect(page).to have_link "", href: admin_post_books_path
    end
    it 'お問い合わせのリンクが表示されているか' do
      expect(page).to have_link "", href: admin_contacts_path
    end
    it 'ログアウトのリンクが表示されているか' do
      expect(page).to have_link "", href: destroy_admin_session_path
    end
    it 'ログアウト後、ログイン画面に遷移しているか' do
      click_link "ログアウト"
      expect(current_path).to eq "/admin/sign_in"
    end
  end

  describe '会員一覧画面のテスト' do
    context '会員一覧画面内容の確認' do
      it 'adminのログイン機能テスト' do
        expect(current_path).to eq '/admin'
      end
      it '会員のニックネームが表示されているか' do
        expect(page).to have_content user.nickname
        expect(page).to have_content other_user.nickname
      end
      it '会員のメールアドレスが記載されているか' do
        expect(page).to have_content user.email
        expect(page).to have_content other_user.email
      end
      it '会員の登録日が記載されているか' do
        expect(page).to have_content user.created_at.strftime('%Y/%m/%d')
        expect(page).to have_content other_user.email
      end
      it '会員ステータスが表示されているか' do
        expect(page).to have_content user.is_deleted
        expect(page).to have_content other_user.is_deleted
      end
      it '会員の編集ボタンが記載されているか' do
        expect(page).to have_link "編集する", href: edit_admin_user_path(user)
        expect(page).to have_link "編集する", href: edit_admin_user_path(other_user)
      end
      it '検索フォーム（キーワード）が表示されているか' do
        expect(page).to have_field "q[nickname_or_email_cont_any]"
      end
      it '検索フォーム（会員ステータス）が表示されているか' do
        expect(page).to have_field "q[is_deleted_eq]"
      end
      it '検索フォーム（検索ボタン）が表示されているか' do
        expect(page).to have_button "検索"
      end
    end

    context '会員編集機能の確認' do
      before do
        edit_link = find_all('a')[7]
        edit_link.click
      end

      it 'ユーザーの編集画面のリンク先の確認' do
        expect(current_path).to eq edit_admin_user_path(user)
      end
      it 'ユーザーの編集フォームで有効が選択されているか' do
        expect(page).to have_checked_field with: '有効'
      end
      it 'ユーザーの編集フォームの保存ボタンがあるか' do
        expect(page).to have_button "編集内容を保存"
      end
      it '実際に変更が反映されるか' do
        choose 'user[is_deleted]', with: '退会済み'
        click_button "編集内容を保存"
        expect(current_path).to eq admin_root_path
        expect(page).to have_content "退会済み"
      end
    end

    context '検索結果の確認' do
      let!(:third_user) { create(:user, nickname: "テスト", email: "test@test", password: 'password', password_confirmation: 'password', is_deleted: '退会済み') }
      let!(:fourth_user) { create(:user, nickname: "サンプル", email: "example@example", password: 'password', password_confirmation: 'password', is_deleted: '有効') }

      it 'ニックネームで検索' do
        fill_in 'q[nickname_or_email_cont_any]', with: "テスト"
        click_button "検索"
        expect(page).to have_content "テスト"
        expect(page).not_to have_content "サンプル"
      end
      it 'メールアドレスで検索' do
        fill_in 'q[nickname_or_email_cont_any]', with: "test@test"
        click_button "検索"
        expect(page).to have_content "テスト"
        expect(page).not_to have_content "サンプル"
      end
      it '会員ステータスで検索' do
        select '退会済み'
        click_button "検索"
        expect(page).to have_content "テスト"
        expect(page).not_to have_content "サンプル"
      end
      it '検索結果がない時は、該当するデータはありませんと表示されるか' do
        fill_in 'q[nickname_or_email_cont_any]', with: "検索結果なし"
        click_button "検索"
        expect(page).to have_content "該当するデータはありません"
      end
    end
  end

  describe 'ジャンル登録の確認' do
    before do
      click_link "ジャンル一覧"
    end

    context '一覧画面の確認' do
      it 'リンク先の確認' do
        expect(current_path).to eq admin_genres_path
      end
      it 'ジャンル名が表示されているか' do
        expect(page).to have_content genre.name
        expect(page).to have_content other_genre.name
      end
      it 'ジャンル名で編集' do
        expect(page).to have_link "編集する", href: edit_admin_genre_path(genre)
      end
      it '登録フォームが表示されているか' do
        expect(page).to have_field "genre[name]"
      end
      it '登録フォームで新規登録ボタンが表示されているか' do
        expect(page).to have_button "新規登録する"
      end
    end

    context 'ジャンル名の新規登録（成功）' do
      before do
        fill_in "genre[name]", with: "小説"
        click_button "新規登録する"
      end

      it 'ジャンル名が表示されている' do
        expect(page).to have_content "小説"
      end
    end

    context 'ジャンル名の新規登録（失敗）' do
      before do
        fill_in "genre[name]", with: ""
        click_button "新規登録する"
      end

      it 'ジャンル名が表示されている' do
        expect(page).to have_content "ジャンル名を入力してください"
      end
    end

    describe 'ジャンル名の編集機能の確認' do
      before do
        @old_genre_name = genre.name
        edit_link = find_all('a')[6]
        edit_link.click
      end

      context '編集画面の確認' do
        it 'リンク先が正しい' do
          expect(current_path).to eq edit_admin_genre_path(genre)
        end
        it 'ジャンル名の編集フォームに名前が設定されているか' do
          expect(page).to have_field "genre[name]", with: @old_genre_name
        end
      end

      context '編集機能の確認（成功）' do
        before do
          fill_in "genre[name]", with: Faker::Lorem.characters(number: 5)
          click_button "編集内容を保存"
        end

        it 'ジャンル一覧画面にリダイレクトされているか' do
          expect(current_path).to eq admin_genres_path
        end
        it 'ジャンルの名称が変更されているか' do
          expect(genre.reload.name).not_to eq @old_genre_name
        end
      end

      context '編集機能の確認（失敗）' do
        before do
          fill_in "genre[name]", with: ""
          click_button "編集内容を保存"
        end

        it 'ジャンル名を入力してくださいのエラーが表示されているか' do
          expect(page).to have_content "ジャンル名を入力してください"
        end
      end
    end
  end

  describe '投稿一覧の確認画面' do
    before do
      click_link "投稿一覧"
    end

    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq admin_post_books_path
      end
      it 'ユーザーのリンク先が正しい' do
        expect(page).to have_link '', href: edit_admin_user_path(post_book.user)
        expect(page).to have_link '', href: edit_admin_user_path(other_post_book.user)
      end
      it '投稿のリンク先が正しい' do
        expect(page).to have_link '', href: admin_post_book_path(post_book)
        expect(page).to have_link '', href: admin_post_book_path(other_post_book)
      end
      it 'ユーザーニックネームが表示されている' do
        expect(page).to have_content post_book.user.nickname
        expect(page).to have_content other_post_book.user.nickname
      end
      it '投稿のタイトルが表示されている' do
        expect(page).to have_content post_book.title
        expect(page).to have_content other_post_book.title
      end
      it '投稿ジャンルが表示されている' do
        expect(page).to have_content post_book.genre.name
        expect(page).to have_content other_post_book.genre.name
      end
      it '投稿コメント数が表示されている' do
        expect(page).to have_content post_book.comments.count
        expect(page).to have_content other_post_book.comments.count
      end
      it '投稿のいいね数が表示されている' do
        expect(page).to have_content post_book.favorites.count
        expect(page).to have_content other_post_book.favorites.count
      end
    end

    describe '検索のテスト' do
      let!(:post_book) { create(:post_book, post_book_author: "夏目漱石", post_book_title: "こころ", genre_id: 1, title: "大人になれなかった先生", content: "面白いです", user_id: 1) }

      context '検索フォームの確認' do
        it '検索ワード' do
          expect(page).to have_field 'q[title_or_post_book_author_or_post_book_title_cont_any]'
        end
        it 'ジャンル' do
          expect(page).to have_field 'q[genre_id_eq]'
        end
        it '日付(From)' do
          expect(page).to have_field 'q[created_at_gteq]'
        end
        it '日付(To)' do
          expect(page).to have_field 'q[created_at_lteq_end_of_day]'
        end
        it '検索ボタンが表示されているか' do
          expect(page).to have_button '検索'
        end
      end

      context '検索結果の確認（見つかる場合）' do
        it '著者名で検索' do
          fill_in 'q[title_or_post_book_author_or_post_book_title_cont_any]', with: '夏目'
          click_button '検索'
          expect(page).to have_content '夏目漱石'
        end
        it '本のタイトルで検索' do
          fill_in 'q[title_or_post_book_author_or_post_book_title_cont_any]', with: 'ここ'
          click_button '検索'
          expect(page).to have_content '夏目漱石'
        end
        it '投稿タイトルで検索' do
          fill_in 'q[title_or_post_book_author_or_post_book_title_cont_any]', with: '大人'
          click_button '検索'
          expect(page).to have_content '夏目漱石'
        end
        it 'ジャンルで検索' do
          find("option[value='1']").select_option
          click_button '検索'
          expect(page).to have_content '夏目漱石'
        end
        it '日付で検索' do
          fill_in 'q[created_at_gteq]', with: '2020-01-01'
          fill_in 'q[created_at_lteq_end_of_day]', with: '2021-12-31'
          click_button '検索'
          expect(page).to have_content '夏目漱石'
        end
      end

      context '検索結果の確認（見つからない場合）' do
        it '著者名で検索' do
          fill_in 'q[title_or_post_book_author_or_post_book_title_cont_any]', with: '芥川'
          click_button '検索'
          expect(page).to have_content '該当するデータはありません'
        end
        it '本のタイトルで検索' do
          fill_in 'q[title_or_post_book_author_or_post_book_title_cont_any]', with: '人間失格'
          click_button '検索'
          expect(page).to have_content '該当するデータはありません'
        end
        it '投稿タイトルで検索' do
          fill_in 'q[title_or_post_book_author_or_post_book_title_cont_any]', with: '純粋性'
          click_button '検索'
          expect(page).to have_content '該当するデータはありません'
        end
        it 'ジャンルで検索' do
          find("option[value='2']").select_option
          click_button '検索'
          expect(page).to have_content '該当するデータはありません'
        end
        it '日付で検索' do
          fill_in 'q[created_at_gteq]', with: '2020-01-01'
          fill_in 'q[created_at_lteq_end_of_day]', with: '2020-12-31'
          click_button '検索'
          expect(page).to have_content '該当するデータはありません'
        end
      end
    end
  end

  describe '投稿詳細画面のテスト' do
    before do
      visit admin_post_book_path(post_book)
    end

    it 'リンクの確認' do
      expect(current_path).to eq "/admin/post_books/#{post_book.id}"
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
    it '削除リンクが表示されているか' do
      expect(page).to have_link '削除する', href: admin_post_book_path(post_book)
    end

    describe '削除機能のテスト' do
      before do
        delete_link = find_all('a')[6]
        delete_link.click
      end

      it '正しく削除される' do
        expect(PostBook.where(id: post_book.id).count).to eq 0
      end
      it 'リダイレクト先が投稿一覧画面になっている' do
        expect(current_path).to eq '/admin/post_books'
      end
    end
  end

  describe 'コメント機能の確認' do
    let!(:comment) { create(:comment, user: other_user, post_book: post_book, comment_content: "コメントです") }
    
    before do
      visit admin_post_book_path(post_book)
    end

    it 'コメントの削除ボタンが表示される' do
      comment = Comment.find_by(post_book_id: post_book)
      expect(page).to have_link '削除する', href: admin_post_book_comment_path(post_book, comment)
    end
    it 'コメントが表示されている' do
      expect(page).to have_content 'コメントです'
    end
    it 'コメントの削除ボタンを押すと、コメントが表示されなくなる' do
      delete_link = find_all('a')[8]
      delete_link.click
      expect(page).not_to have_content 'コメントです'
    end
    it 'コメントの削除ボタンを押すと、コメントが正しく削除されている' do
      delete_link = find_all('a')[8]
      expect { delete_link.click }.to change(post_book.comments, :count).by(-1)
    end
  end

  describe 'お問い合わせ画面の確認' do
    let!(:contact) { create(:contact, name: Faker::Lorem.characters(number: 5), email: Faker::Internet.email, content: Faker::Lorem.characters(number: 100)) }
    let!(:other_contact) { create(:contact, name: Faker::Lorem.characters(number: 5), email: Faker::Internet.email, content: Faker::Lorem.characters(number: 100)) }

    before do
      visit admin_contacts_path
    end

    context 'お問い合わせ一覧画面の確認' do
      it 'リンク先の確認' do
        expect(current_path).to eq "/admin/contacts"
      end
      it 'お問い合わせの名前があるか' do
        expect(page).to have_content contact.name
        expect(page).to have_content other_contact.name
      end
      it 'お問い合わせのメールアドレスがあるか' do
        expect(page).to have_content contact.email
        expect(page).to have_content other_contact.email
      end
      it 'お問い合わせの内容があるか' do
        expect(page).to have_content contact.content.truncate(10)
        expect(page).to have_content other_contact.content.truncate(10)
      end
      it 'お問い合わせの詳細リンクがあるか' do
        expect(page).to have_link contact.name, href: admin_contact_path(contact)
        expect(page).to have_link other_contact.name, href: admin_contact_path(other_contact)
      end
    end

    context 'お問い合わせ詳細画面の確認' do
      before do
        click_link contact.name
      end

      it 'リンク先があっているか' do
        expect(current_path).to eq "/admin/contacts/#{contact.id}"
      end
      it '問い合わせの名前が表示されている' do
        expect(page).to have_content contact.name
      end
      it '問い合わせのメールアドレスが表示されている' do
        expect(page).to have_content contact.email
      end
      it '問い合わせの内容が表示されている' do
        expect(page).to have_content contact.content
      end
    end
  end
end
