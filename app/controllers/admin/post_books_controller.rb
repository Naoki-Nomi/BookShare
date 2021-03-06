class Admin::PostBooksController < ApplicationController
  before_action :authenticate_admin!

  def index
    @search = PostBook.ransack(params[:q])
    @post_books = @search.result.page(params[:page]).reverse_order.includes(:user, :genre, :favorites, :comments)
    @genres = Genre.all
  end

  def show
    @post_book = PostBook.find(params[:id])
  end

  def destroy
    post_book = PostBook.find(params[:id])
    post_book.destroy
    redirect_to admin_post_books_path
  end
end
