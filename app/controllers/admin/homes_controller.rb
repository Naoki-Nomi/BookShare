class Admin::HomesController < ApplicationController
  before_action :authenticate_admin!

  def top
    @search = User.ransack(params[:q])
    @users = @search.result.page(params[:page]).reverse_order
  end
end
