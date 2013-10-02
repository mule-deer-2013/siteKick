 class UsersController < ApplicationController

  before_filter :check_user, only: [:new]

  def new
    @user = User.new
  end
  
  def create
    @user = User.new(params[:user])
    if @user.save
      redirect_to new_page_path
    else
      redirect_to root_url
    end
  end

  private

  def check_user
    redirect_to new_page_path if current_user
  end
end
