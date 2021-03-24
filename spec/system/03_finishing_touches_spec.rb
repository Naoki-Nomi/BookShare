# frozen_string_literal: true

require 'rails_helper'

describe '[STEP3] 仕上げのテスト（他ユーザーの画面の確認）' do
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

  describe '他ユーザーのマイページ画面' do
    before do
      visit user_path(other_user)
    end

    it 'リンク先の確認' do
      expect(current_path).to eq "/users/#{other_user.id}"
    end
    it '他ユーザーのマイページ編集画面には遷移できず、マイページ画面にリダイレクトされる' do
      visit edit_user_path(other_user)
      expect(current_path).to eq "/users/#{other_user.id}"
    end
    it '他ユーザーの退会確認画面には遷移できず、マイページ画面にリダイレクトされる' do
      visit user_confirm_path(other_user)
      expect(current_path).to eq "/users/#{other_user.id}"
    end
  end

  describe '他ユーザーの投稿一覧画面の確認' do
    before do
      visit user_path(other_user)
      click_link "#{other_user.nickname}さんの投稿一覧を閲覧する"
    end

    context '投稿一覧画面の確認' do
      it 'リンク先が正しいか' do
        expect(current_path).to eq '/post_books'
      end
      it '他ユーザーの投稿のみ表示されているか' do
        expect(page).to have_content other_post_book.title
        expect(page).not_to have_content post_book.title
      end
      it '他ユーザーのニックネームのみ表示されているか' do
        expect(page).to have_content other_user.nickname
        expect(page).not_to have_content user.nickname
      end
    end

    context '検索を実行しても他ユーザーの投稿のみ表示される' do
      let!(:second_other_post_book) { create(:post_book, post_book_author: "夏目漱石", post_book_title: "こころ", genre_id: 1, title: "大人になれなかった先生", content: "面白いです", user_id: 2) }
      let!(:second_post_book) { create(:post_book, post_book_author: "芥川龍之介", post_book_title: "人間失格", genre_id: 2, title: "純粋さとは", content: "興味深いです", user_id: 1) }

      it '夏目では検索できる' do
        fill_in 'search', with: '夏目'
        click_button '検索'
        expect(page).to have_content '夏目漱石'
        expect(current_path).to eq "/post_books/search"
      end
      it '芥川では検索できない' do
        fill_in 'search', with: '芥川'
        click_button '検索'
        expect(page).to have_content '該当するデータはありません'
        expect(current_path).to eq "/post_books/search"
      end
      it 'こころでは検索できる' do
        fill_in 'search', with: 'こころ'
        click_button '検索'
        expect(page).to have_content '夏目漱石'
        expect(current_path).to eq "/post_books/search"
      end
      it '人間失格では検索できない' do
        fill_in 'search', with: '人間失格'
        click_button '検索'
        expect(page).to have_content '該当するデータはありません'
        expect(current_path).to eq "/post_books/search"
      end
      it '大人では検索できる' do
        fill_in 'search', with: '大人'
        click_button '検索'
        expect(page).to have_content '夏目漱石'
        expect(current_path).to eq "/post_books/search"
      end
      it '純粋では検索できない' do
        fill_in 'search', with: '純粋'
        click_button '検索'
        expect(page).to have_content '該当するデータはありません'
        expect(current_path).to eq "/post_books/search"
      end
      it 'ジャンル名(1)では検索できる' do
        find("option[value='1']").select_option
        click_button '検索'
        expect(page).to have_content '夏目漱石'
        expect(current_path).to eq "/post_books/search"
      end
      it 'ジャンル名(2)では検索できない' do
        find("option[value='2']").select_option
        click_button '検索'
        expect(page).to have_content '該当するデータはありません'
        expect(current_path).to eq "/post_books/search"
      end
      it '検索後もユーザーの名前のままである' do
        fill_in 'search', with: '夏目'
        click_button '検索'
        expect(page).to have_content other_user.nickname
        expect(page).not_to have_content user.nickname
      end
    end
  end

  describe '他ユーザーの投稿詳細画面' do
    before do
      visit post_book_path(other_post_book)
    end

    context '表示内容の確認' do
      it 'リンク先の確認' do
        expect(current_path).to eq "/post_books/#{other_post_book.id}"
      end
      it '他ユーザーのニックネームが表示されている' do
        expect(page).to have_content other_post_book.user.nickname
      end
      it '他ユーザーの投稿タイトルが表示されている' do
        expect(page).to have_content other_post_book.title
      end
      it '他ユーザーの詳細画面なので、編集リンクが表示されていない' do
        expect(page).not_to have_link '編集する', href: edit_post_book_path(other_post_book)
      end
      it '他ユーザーの詳細画面なので、削除リンクが表示されていない' do
        expect(page).not_to have_link '削除する', href: post_book_path(other_post_book)
      end
    end

    context '投稿編集機能の確認' do
      it '他ユーザーの投稿編集画面には遷移されず、投稿詳細画面にリダイレクトされる' do
        visit edit_post_book_path(other_post_book)
        expect(current_path).to eq "/post_books/#{other_post_book.id}"
      end
    end

    describe 'コメント機能の確認' do
      context 'コメント投稿機能（成功）のテスト' do
        before do
          fill_in 'comment[comment_content]', with: "コメントです"
        end
        it 'コメントが保存されている' do
          expect { click_button 'コメントを投稿する' }.to change(other_post_book.comments, :count).by(1)
        end
        it 'コメントが画面上に表示されている' do
          click_button 'コメントを投稿する'
          expect(page).to have_content "コメントです"
        end
        it 'コメントの件数が+1されている' do
          click_button 'コメントを投稿する'
          expect(other_post_book.comments.count).to eq 1
        end
      end

      context 'コメント投稿機能（失敗）のテスト' do
        before do
          fill_in 'comment[comment_content]', with: ""
          click_button 'コメントを投稿する'
        end
        it 'コメント内容を入力してくださいのエラーが表示される' do
          expect(page).to have_content "コメント内容を入力してください"
        end
      end

      context 'コメント削除機能のテスト' do
        before do
          fill_in 'comment[comment_content]', with: "コメントです"
          click_button 'コメントを投稿する'
        end
        it 'コメントの削除ボタンが表示される' do
          comment = Comment.find_by(post_book_id: other_post_book)
          expect(page).to have_link '削除する', href: post_book_comment_path(other_post_book, comment)
        end
        it 'コメントの削除ボタンを押すと、コメントが表示されなくなる' do
          click_link '削除する'
          expect(page).not_to have_content 'コメントです'
        end
        it 'コメントの削除ボタンを押すと、コメントが正しく削除されている' do
          expect{ click_link '削除する' }.to change(other_post_book.comments, :count).by(-1)
        end
      end
    end

    describe '投稿いいね機能の確認' do
      before do
        click_link 'いいねする'
      end

      context '投稿にいいねした場合' do
        it 'いいねのカウント数が+１されている' do
          expect(other_post_book.favorites.count).to eq 1
        end
        it 'いいねを取り消すが表示されている' do
          expect(page).to have_content 'いいねを取り消す'
        end
        it 'いいねした投稿をマイページから閲覧することができる' do
          visit user_path(user.id)
          favorite_link = find_all('a')[9]
          favorite_link.click
          expect(page).to have_content other_post_book.title
          expect(current_path).to eq "/favorites"
        end
      end

      context '投稿のいいねを取り消した場合' do
        before do
          click_link 'いいねを取り消す'
        end
        it 'いいねのカウント数が-１されている' do
          expect(other_post_book.favorites.count).to eq 0
        end
        it 'いいねするが表示されている' do
          expect(page).to have_content 'いいねする'
        end
      end
    end
  end

  describe '他ユーザーの読書記録一覧' do
    before do
      visit user_path(other_user)
      click_link "#{other_user.nickname}さんの読書一覧を閲覧する"
    end

     context '読書一覧画面の確認' do
      it 'リンク先が正しいか' do
        expect(current_path).to eq '/books'
      end
      it '他ユーザーの読書のみ表示されているか' do
        expect(page).to have_content other_book.book_title
        expect(page).not_to have_content book.book_title
      end
      it '他ユーザーのニックネームのみ表示されているか' do
        expect(page).to have_content other_user.nickname
        expect(page).not_to have_content user.nickname
      end
    end

    context '検索を実行しても他ユーザーの読書のみ表示される' do
      let!(:second_other_book) { create(:book, author: "夏目漱石", book_title: "こころ", genre_id: 1, note: "面白いです", read_date: "2021-02-01", user_id: 2) }
      let!(:second_book) { create(:book, author: "芥川龍之介", book_title: "人間失格", genre_id: 2, note: "純粋さとは", read_date: "2020-12-31", user_id: 1) }

      it '夏目では検索できる' do
        fill_in 'search', with: '夏目'
        click_button '検索'
        expect(page).to have_content '夏目漱石'
        expect(current_path).to eq "/books/search"
      end
      it '芥川では検索できない' do
        fill_in 'search', with: '芥川'
        click_button '検索'
        expect(page).to have_content '該当するデータはありません'
        expect(current_path).to eq "/books/search"
      end
      it 'こころでは検索できる' do
        fill_in 'search', with: 'こころ'
        click_button '検索'
        expect(page).to have_content '夏目漱石'
        expect(current_path).to eq "/books/search"
      end
      it '人間失格では検索できない' do
        fill_in 'search', with: '人間失格'
        click_button '検索'
        expect(page).to have_content '該当するデータはありません'
        expect(current_path).to eq "/books/search"
      end
      it 'ジャンル名(1)では検索できる' do
        find("option[value='1']").select_option
        click_button '検索'
        expect(page).to have_content '夏目漱石'
        expect(current_path).to eq "/books/search"
      end
      it 'ジャンル名(2)では検索できない' do
        find("option[value='2']").select_option
        click_button '検索'
        expect(page).to have_content '該当するデータはありません'
        expect(current_path).to eq "/books/search"
      end
      it '日付で検索できる' do
        fill_in 'read_from', with: '2021-01-01'
        fill_in 'read_to', with: '2021-02-28'
        click_button '検索'
        expect(page).to have_content '夏目漱石'
        expect(current_path).to eq "/books/search"
      end
      it '検索後もユーザーの名前のままである' do
        fill_in 'search', with: '夏目'
        click_button '検索'
        expect(page).to have_content other_user.nickname
        expect(page).not_to have_content user.nickname
      end
    end
    context '他ユーザーの読書グラフの確認' do
      before do
        click_on "グラフで確認"
      end
      it 'リンク先の確認' do
        expect(current_path).to eq "/books/#{other_book.user.id}/detail"
      end
      it '他ユーザーのニックネームが表示されている' do
        expect(page).to have_content other_book.user.nickname
      end
    end
  end

  describe '他ユーザーの読書詳細画面の確認' do
    before do
      visit book_path(other_book)
    end

    it 'リンク先の確認' do
      expect(current_path).to eq "/books/#{other_book.id}"
    end
    it '他ユーザーのニックネームが表示されている' do
      expect(page).to have_content other_book.user.nickname
      expect(page).not_to have_content user.nickname
    end
    it '編集のリンク先が表示されていない' do
      expect(page).not_to have_link '編集する', href: edit_book_path(other_book)
    end
    it '削除のリンク先が表示されていない' do
      expect(page).not_to have_link '削除する', href: book_path(other_book)
    end
    it '編集することができず、読書詳細画面にリダイレクトされる' do
      visit edit_book_path(other_book)
      expect(current_path).to eq "/books/#{other_book.id}"
    end
  end

  describe 'フォロー機能の確認' do
    before do
      visit user_path(other_user)
      click_link "フォローする"
    end

    context 'ユーザーが他ユーザーをフォローした場合' do
      it 'リンク先が正しいか' do
        expect(current_path).to eq "/users/#{other_user.id}"
      end
      it 'フォローするをクリックすると、フォロワー数としてカウントされる' do
        expect(other_user.followed.count).to eq 1
      end
      it 'フォローするをクリックすると、フォロー数としてカウントされる' do
        expect(user.follower.count).to eq 1
      end
      it '他ユーザーのマイページ上でフォロー中と表示されているか' do
        expect(page).to have_content "フォロー中"
      end
      it '他ユーザーのフォロワー一覧に追加されている' do
        followed_link = find_all('a')[9]
        followed_link.click
        expect(current_path).to eq '/relationships'
        expect(page).to have_content "#{other_user.nickname}さんのフォロワー"
        expect(page).to have_content user.nickname
      end
    end

    context 'ユーザーが他ユーザーのフォローを外す場合' do
      before do
        click_link "フォロー中"
      end

      it 'フォロワー数が0になる' do
        expect(other_user.followed.count).to eq 0
      end
      it 'フォロー数が0になる' do
        expect(user.follower.count).to eq 0
      end
      it '他ユーザーのフォロワー一覧にデータが表示されない' do
        followed_link = find_all('a')[9]
        followed_link.click
        expect(current_path).to eq '/relationships'
        expect(page).to have_content "該当するデータはありません"
      end
    end

    context 'フォロワーの検索機能の確認' do
      before do
        followed_link = find_all('a')[9]
        followed_link.click
      end

      it '検索フォームがあるか' do
        expect(page).to have_field 'nickname'
      end
      it '検索ボタンがあるか' do
        expect(page).to have_button '検索'
      end
      it 'ユーザーのニックネームで検索すると、ユーザーの投稿数が表示される' do
        fill_in 'nickname', with: user.nickname
        click_button '検索'
        expect(page).to have_content user.post_books.count
        expect(current_path).to eq "/relationships/search"
      end
    end

    context 'フォローの検索機能の確認' do
      before do
        click_link "マイページ"
        follower_link = find_all('a')[7]
        follower_link.click
      end

      it 'URLが正しいか' do
        expect(current_path).to eq '/relationships'
      end
      it '検索フォームがあるか' do
        expect(page).to have_field 'nickname'
      end
      it '検索ボタンがあるか' do
        expect(page).to have_button '検索'
      end
      it '他ユーザーのニックネームで検索すると、他ユーザーの投稿数が表示される' do
        fill_in 'nickname', with: other_user.nickname
        click_button '検索'
        expect(page).to have_content other_user.post_books.count
        expect(current_path).to eq "/relationships/search"
      end
    end
  end

  describe '通知機能の確認' do
    before do
      visit user_path(other_user)
      click_link "フォローする"
      visit post_book_path(other_post_book)
      click_link "いいねする"
      fill_in "comment[comment_content]", with: "コメントです"
      click_button "コメントを投稿する"
      click_link 'ログアウト'

      visit new_user_session_path
      fill_in 'user[email]', with: other_user.email
      fill_in 'user[password]', with: other_user.password
      click_button 'ログイン'
    end

    context 'マイページ上の確認' do
      it 'リンク先の確認' do
        expect(current_path).to eq "/users/#{other_user.id}"
      end
      it '通知マークが表示されている' do
        expect(page).to have_selector ".fa-circle"
      end
      it '通知マークが消えている' do
        click_link "通知を確認する"
        click_link "マイページ"
        expect(page).not_to have_selector ".fa-circle"
      end
    end

    context '通知画面の確認' do
      before do
        click_link "通知を確認する"
      end

      it 'リンク先の確認' do
        expect(current_path).to eq "/notifications"
      end
      it '通知を空にするのリンク先が表示されているか' do
        expect(page).to have_link "通知を空にする", href: destroy_all_notification_path
      end
      it 'フォローの通知がきている' do
        expect(page).to have_content "#{user.nickname} さんが #{other_user.nickname}さんをフォローしました"
      end
      it '投稿に対するいいねの通知がきている' do
        expect(page).to have_content "#{user.nickname} さんが #{other_user.nickname}さんの投稿 にいいねしました"
      end
      it 'いいねされた投稿のリンク先が表示されており、投稿の詳細画面に遷移する' do
        favorite_link = find_all('a')[9]
        favorite_link.click
        expect(current_path).to eq "/post_books/#{other_post_book.id}"
      end
      it '投稿に対するコメントの通知がきている' do
        expect(page).to have_content "#{user.nickname} さんが #{other_user.nickname}さんの投稿 にコメントしました"
      end
      it 'コメントされた投稿のリンク先が表示されており、投稿の詳細画面に遷移する' do
        favorite_link = find_all('a')[11]
        favorite_link.click
        expect(current_path).to eq "/post_books/#{other_post_book.id}"
      end
    end

    context '通知削除機能の確認' do
      before do
        click_link "通知を確認する"
      end

      it '通知を削除すると、通知はありませんが表示される' do
        click_link "通知を空にする"
        expect(page).to have_content "通知はありません"
      end
      it '実際に通知が削除されている' do
        expect{ click_link "通知を空にする"}.to change { Notification.count }.by(-3)
      end
    end
  end
end