class FavoritesController < ApplicationController

  def create
    post_book = PostBook.find(params[:post_book_id])
    favorite = Favorite.new
    favorite.user_id = current_user.id
    favorite.post_book_id = post_book.id
    if favorite.save
      post_book.create_notification_favorite(current_user)
    end
    redirect_to  post_book_path(post_book)
  end

  def destroy
    Favorite.find_by(user_id: current_user.id, post_book_id: params[:post_book_id]).destroy
    redirect_to  post_book_path(params[:post_book_id])
  end

end
