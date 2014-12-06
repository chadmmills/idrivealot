class Admin::UsersController < ApplicationController

  def index
    @users = User.order("updated_at DESC").all
  end

end
