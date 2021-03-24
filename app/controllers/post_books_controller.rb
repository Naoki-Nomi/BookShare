class PostBooksController < ApplicationController
  before_action :authenticate_user!

  def new
    @post_book = PostBook.new
    @genres = Genre.all
  end

  def create
    @post_book = PostBook.new(post_book_params)
    @post_book.user_id = current_user.id
    if @post_book.save
      redirect_to post_books_path
    else
      @genres = Genre.all
      render :new
    end
  end

  USER_POST_BOOK = "0"

  # book_sortが0の時、特定のユーザーの投稿一覧を表示する
  def index
    @genres = Genre.all
    @user = User.find_by(id: params[:user_id])
    @title = "投稿一覧"
    @url = search_post_books_path
    if params[:book_sort] == USER_POST_BOOK
      @post_books = PostBook.where(user_id: params[:user_id])
      @post_books = @post_books.page(params[:page]).reverse_order.includes(:genre, :user, :comments, :favorites)
    else
      @post_books = PostBook.page(params[:page]).reverse_order.includes(:genre, :user, :comments, :favorites)
    end
  end

  def search
    @genres = Genre.all
    @user = User.find_by(id: params[:user_id])
    @title = "投稿一覧"
    @url = search_post_books_path
    @post_books = PostBook.search(params[:user_id], params[:search], params[:genre_id], params[:post_from], params[:post_to])
    @post_books = @post_books.page(params[:page]).reverse_order.includes(:genre, :user, :comments, :favorites)
  end

  def show
    @post_book = PostBook.find(params[:id])
    @comment = Comment.new
  end

  def edit
    @post_book = PostBook.find(params[:id])
    @genres = Genre.all
    unless @post_book.user == current_user
      redirect_to post_book_path(@post_book)
    end
  end

  def update
    @post_book = PostBook.find(params[:id])
    if @post_book.update(post_book_params)
      redirect_to post_book_path(@post_book)
    else
      @genres = Genre.all
      render :edit
    end
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
