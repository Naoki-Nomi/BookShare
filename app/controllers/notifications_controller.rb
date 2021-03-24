class NotificationsController < ApplicationController
  before_action :authenticate_user!

  # 一度確認した通理は全て確認済みにする
  def index
    @notifications = current_user.passive_notifications
    @notifications.where(checked: false).each do |notification|
      notification.update_attributes(checked: true)
    end
  end

  def destroy_all
    current_user.passive_notifications.destroy_all
    redirect_to notifications_path
  end
end
