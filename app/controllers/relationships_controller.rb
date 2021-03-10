class RelationshipsController < ApplicationController
  before_action :authenticate_user!

  def follow
    current_user.follow(params[:id])
    user = User.find(params[:id])
    user.create_notification_follow(current_user)
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
      @title = "フォロー"
    elsif params[:relationship_order] == "1"
      @user = User.find(params[:id])
      @users = @user.follower_user
      @title = "フォロワー"
    else
      redirect_to root_path
    end
  end

  def search
    if params[:relationship_order] == "0"
      @user = User.find(params[:id])
      @users = @user.following_user.where("nickname Like?", "%#{params[:nickname]}%")
      @title = "フォロー"
    elsif params[:relationship_order] == "1"
      @user = User.find(params[:id])
      @users = @user.follower_user.where("nickname Like?", "%#{params[:nickname]}%")
      @title = "フォロワー"
    else
      redirect_to root_path
    end
  end
end
