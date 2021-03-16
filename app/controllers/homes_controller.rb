class HomesController < ApplicationController
  def top
  end

  def new_guest
    user = User.find_or_create_by!(nickname: "ゲスト", email: 'guest@example.com') do |user|
      user.password = SecureRandom.urlsafe_base64
    end
    sign_in user
    redirect_to user_path(user), notice: 'ゲストユーザーとしてログインしました。'
  end
end
