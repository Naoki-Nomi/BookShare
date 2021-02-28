class PostBooksController < ApplicationController

  def new
    @post_book = PostBook.new
    @genres = Genre.all
  end

  def create
    post_book = PostBook.new(post_book_params)
    post_book.user_id = current_user.id
    post_book.save
    redirect_to post_books_path
  end

  def index
    @post_books = PostBook.all
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
    params.require(:post_book).permit(:genre_id, :title, :content, :post_book_title, :post_book_author, :post_book_image)
  end

end
