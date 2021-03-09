class UsersController < ApplicationController

  def show
    @user = User.find(params[:id])
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    user = User.find(params[:id])
    user.update(user_params)
    redirect_to user_path(user)
  end

  def confirm
    @user = User.find(params[:id])
    unless @user.id == current_user.id
      redirect_to root_path
    end
  end

  def quit
    user = User.find(params[:id])
    user.update_attributes(is_deleted: true)
    reset_session
    redirect_to root_path
  end

  private

  def user_params
    params.require(:user).permit(:nickname, :profile_image, :introduction)
  end

end
