class RelationshipsController < ApplicationController

  def follow
    current_user.follow(params[:id])
    redirect_to user_path(params[:id])
  end

  def unfollow
    current_user.unfollow(params[:id])
    redirect_to user_path(params[:id])
  end

  def index
    if params[:relationship_order] == "0"
      @user = User.find(params[:id])
      @users = @user.following_user
    elsif params[:relationship_order] == "1"
      @user = User.find(params[:id])
      @users = @user.follower_user
    else
      redirect_to root_path
    end
  end

end
