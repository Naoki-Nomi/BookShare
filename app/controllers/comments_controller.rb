class CommentsController < ApplicationController
  def create
    @post_book = PostBook.find(params[:post_book_id])
    @comment = Comment.new(comment_params)
    @comment.post_book_id = @post_book.id
    @comment.user_id = current_user.id
    if @comment.save
      @post_book.create_notification_comment(current_user, @comment.id)
      redirect_to post_book_path(@post_book)
    else
      render 'post_books/show'
    end
  end

  def destroy
    Comment.find_by(id: params[:id], post_book_id: params[:post_book_id]).destroy
    redirect_to post_book_path(params[:post_book_id])
  end

  private

  def comment_params
    params.require(:comment).permit(:comment_content)
  end
end
