class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:nickname])
  end

  private

  #サインイン後、Adminは会員一覧にリダイレクトする

  def after_sign_in_path_for(resource)
    case resource
    when Admin
      admin_root_path
    when User
      user_path(current_user)
    end
  end

  #サインアウト後、Adminはサインイン画面にリダイレクトする

  def after_sign_out_path_for(resource_or_scope)
    if resource_or_scope == :admin
      new_admin_session_path
    elsif resource_or_scope == :customer
      root_path
    else
      root_path
    end
  end

end
