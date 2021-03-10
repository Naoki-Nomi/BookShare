class Admin::CommentsController < ApplicationController
  def destroy
    Comment.find_by(id: params[:id], post_book_id: params[:post_book_id]).destroy
    redirect_to admin_post_book_path(params[:post_book_id])
  end
end
