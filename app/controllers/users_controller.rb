class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: [:show, :edit, :update, :confirm, :quit]

  def show
  end

  def edit
    unless @user == current_user
      redirect_to user_path(@user), notice: '編集できません'
    end
  end

  def update
    if @user.email == "guest@example.com"
      redirect_to user_path(@user), notice: 'ゲストユーザーは編集できません'
    elsif @user.update(user_params)
      redirect_to user_path(@user)
    else
      render :edit
    end
  end

  def confirm
    if @user.id != current_user.id
      redirect_to user_path(@user), notice: '編集できません'
    elsif @user.email == "guest@example.com"
      redirect_to user_path(@user), notice: 'ゲストユーザーは編集できません'
    end
  end

  def quit
    @user.update_attributes(is_deleted: true)
    reset_session
    redirect_to root_path
  end

  private

  def user_params
    params.require(:user).permit(:nickname, :profile_image, :introduction, :email)
  end

  def set_user
    @user = User.find(params[:id])
  end
end
