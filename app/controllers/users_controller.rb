class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :fetch_user, only: [:enable, :disable]

  def index
    @users = User.all
  end

  def disable
    @user.update_attributes!(is_active: false)
    flash[:success] = "User #{@user.email} disabled"
    redirect_to :users
  end

  def enable
    @user.update_attributes!(is_active: true)
    flash[:success] = "User #{@user.email} enabled"
    redirect_to :users
  end

  protected

  def fetch_user
    @user = User.find(params.require(:id))
  end
end
