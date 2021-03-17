class UsersController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = User.find(params[:id])
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.email == "guest@example.com"
      redirect_to user_path(@user), notice: 'ゲストユーザーは編集できません'
    elsif @user.update(user_params)
      redirect_to user_path(@user)
    else
      render :edit
    end
  end

  def confirm
    @user = User.find(params[:id])
    if @user.id != current_user.id
      redirect_to root_path
    elsif @user.email == "guest@example.com"
      redirect_to user_path, notice: 'ゲストユーザーは編集できません'
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
    params.require(:user).permit(:nickname, :profile_image, :introduction, :email)
  end
end
