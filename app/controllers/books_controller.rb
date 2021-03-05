class BooksController < ApplicationController

  def new
    @book = Book.new
    @genres = Genre.all
  end

  def create
    book = Book.new(book_params)
    book.user_id = current_user.id
    book.save
    redirect_to books_path
  end

  def index
    @genres = Genre.all
    if params[:book_sort] == "0"
      @books = Book.where(user_id: params[:user_id])
    else
      @books = Book.where(user_id: current_user.id)
    end
  end

  def search
    @genres = Genre.all
    @books = Book.search(params[:user_id], params[:search], params[:genre_id], params[:read_from], params[:read_to])
  end

  def show
    @book = Book.find(params[:id])
  end

  def edit
    @book = Book.find(params[:id])
    @genres = Genre.all
  end

  def update
    book = Book.find(params[:id])
    book.update(book_params)
    redirect_to book_path(book)
  end

  def destroy
    book = Book.find(params[:id])
    book.destroy
    redirect_to books_path
  end

  def detail
    @books = Book.where(user_id: params[:user_id])

    # @read_date_for_graph = @books.group(:read_date).count
    @genre_for_graph = @books.joins(:genre).group("genres.name").count

    if params[:period] == "0"
      @books_number = @books.group_by_year(:read_date).count
    else
      @books_number = @books.group_by_month(:read_date).count
    end

    if params[:author_number]
        author_number = nil
    else
        author_number = "5"
    end

    @author_for_graph = @books.group(:author).order('count_all DESC').limit(author_number).count

  end

  private

  def book_params
    params.require(:book).permit(:genre_id, :book_title, :author, :note, :read_date)
  end

end
