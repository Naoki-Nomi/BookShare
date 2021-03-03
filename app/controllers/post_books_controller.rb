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
    @post_book = PostBook.find(params[:id])
    @comment = Comment.new
  end

  def edit
    @post_book = PostBook.find(params[:id])
    @genres = Genre.all
  end

  def update
    post_book = PostBook.find(params[:id])
    post_book.update(post_book_params)
    redirect_to post_book_path(post_book)
  end

  def destroy
    @post_book = PostBook.find(params[:id])
    @post_book.delete
    redirect_to post_books_path
  end

  private

  def post_book_params
    params.require(:post_book).permit(:genre_id, :title, :content, :post_book_title, :post_book_author, :post_book_image)
  end

end