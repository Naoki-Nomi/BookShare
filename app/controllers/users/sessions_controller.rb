# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  before_action :reject_user, only: [:create]

  def reject_user
    user = User.find_by(email: params[:user][:email])
    if user
      if user.is_deleted == "退会済み"
        flash[:none] = "退会済みです。"
        redirect_to new_user_session_path
      end
    end
  end
end
