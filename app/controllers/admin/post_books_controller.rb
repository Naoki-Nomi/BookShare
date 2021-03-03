class Admin::PostBooksController < ApplicationController

  def index
    @post_books = PostBook.all
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
