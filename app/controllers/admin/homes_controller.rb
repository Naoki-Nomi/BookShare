class Admin::HomesController < ApplicationController
  def top
    @search = User.ransack(params[:q])
    @users = @search.result.page(params[:page]).reverse_order
  end
end
