class RelationshipsController < ApplicationController
  before_action :authenticate_user!

  def follow
    current_user.follow(params[:id])
    user = User.find(params[:id])
    user.create_notification_follow(current_user)
    redirect_to user_path(user)
  end

  def unfollow
    current_user.unfollow(params[:id])
    redirect_to user_path(params[:id])
  end

  FOLLOW_INDEX = "0"
  FOLLOWER_INDEX = "1"

  # relationship_orderが0の時は、フォロー一覧、1の時はフォロワー一覧を表示する
  def index
    if params[:relationship_order] == FOLLOW_INDEX
      @user = User.find(params[:id])
      @users = @user.get_following_users(params[:page])
      @title = "フォロー"
    elsif params[:relationship_order] == FOLLOWER_INDEX
      @user = User.find(params[:id])
      @users = @user.get_follower_users(params[:page])
      @title = "フォロワー"
    else
      redirect_to root_path
    end
  end

  def search
    if params[:relationship_order] == FOLLOW_INDEX
      @user = User.find(params[:id])
      @users = @user.get_search_following_users(params[:nickname], params[:page])
      @title = "フォロー"
    elsif params[:relationship_order] == FOLLOWER_INDEX
      @user = User.find(params[:id])
      @users = @user.get_search_follower_users(params[:nickname], params[:page])
      @title = "フォロワー"
    else
      redirect_to root_path
    end
  end
end
