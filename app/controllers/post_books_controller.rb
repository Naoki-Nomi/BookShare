class PostBooksController < ApplicationController

  def new
    @post_book = PostBook.new
    @genres = Genre.all
  end

  def create
    post_book = PostBook.new(post_book_params)
    post_book.save
    redirect_to post_books_path
  end

  def index
  end

  def show
  end

  def edit
  end

  def update
  end

  def destroy
  end

  private

  def post_book_params
  end

end
