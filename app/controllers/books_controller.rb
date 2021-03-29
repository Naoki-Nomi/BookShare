class BooksController < ApplicationController
  before_action :authenticate_user!

  def new
    @book = Book.new
    @genres = Genre.all
  end

  def create
    @book = Book.new(book_params)
    @book.user_id = current_user.id
    if @book.save
      redirect_to books_path(user_id: @book.user_id)
    else
      @genres = Genre.all
      render :new
    end
  end

  OTHER_USER_BOOK = "0"
  # book_sortパラムスが0の時、他ユーザーの読書記録を表示。それ以外は、自分の読書記録を表示。
  def index
    @genres = Genre.all
    @user = User.find_by(id: params[:user_id])
    if params[:book_sort] == OTHER_USER_BOOK
      @books = Book.book_index(params[:user_id], params[:page])
    else
      @books = Book.book_index(current_user.id, params[:page])
    end
  end

  def search
    @genres = Genre.all
    @user = User.find_by(id: params[:user_id])
    @books = Book.search(params[:user_id], params[:search], params[:genre_id], params[:read_from], params[:read_to]).order(read_date: "DESC").page(params[:page]).includes(:genre)
  end

  def show
    @book = Book.find(params[:id])
  end

  def edit
    @book = Book.find(params[:id])
    @genres = Genre.all
    if @book.user_id == current_user.id
      render :edit
    else
      redirect_to book_path(@book)
    end
  end

  def update
    @book = Book.find(params[:id])
    if @book.update(book_params)
      redirect_to book_path(@book)
    else
      @genres = Genre.all
      render :edit
    end
  end

  def destroy
    book = Book.find(params[:id])
    book.destroy
    redirect_to books_path(user_id: book.user_id)
  end

  WEEK_READ_BOOK = "0"
  YEAR_READ_BOOK = "1"
  TEN_AUTHOR_NUMBER = "0"
  ALL_AUTHOR_NUMBER = "1"

  def detail
    @books = Book.where(user_id: params[:user_id])
    @user = User.find_by(id: params[:user_id])

    # ジャンルのグラフ用にジャンルごとの件数をハッシュ化
    @genre_for_graph = Book.genre_for_graph(params[:user_id])

    # 読書数の経時変化（デフォルトでは月毎での表示）
    if params[:period] == WEEK_READ_BOOK
      @books_for_graph = Book.week_read_book(params[:user_id])
    elsif params[:period] == YEAR_READ_BOOK
      @books_for_graph = Book.year_read_book(params[:user_id])
    else
      @books_for_graph = Book.month_read_book(params[:user_id])
    end

    # 著者数のランキング（デフォルトでは上位5名での表示）
    if params[:author_number] == TEN_AUTHOR_NUMBER
      author_number = "10"
    elsif params[:author_number] == ALL_AUTHOR_NUMBER
      author_number = nil
    else
      author_number = "5"
    end
    @author_for_graph = Book.author_number(params[:user_id], author_number)
  end

  private

  def book_params
    params.require(:book).permit(:genre_id, :book_title, :author, :note, :read_date)
  end

end
