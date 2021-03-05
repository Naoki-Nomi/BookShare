class Admin::HomesController < ApplicationController

  def top
    @search = User.ransack(params[:q])
    @users = @search.result
  end

end
