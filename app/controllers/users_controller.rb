class UsersController < ApplicationController

before_action :allow_without_password, only: [:update]

  def index
    @user = User.all.order(:id)
  end

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def edit
    @user = User.find(params[:id])
  end

    def create
    user = User.new(user_params)
    if user.save
      redirect_to users_path
    else
      redirect_to new_user_path
    end
  end

  def update
    @user = User.find(params[:id])

    if @user.update(user_params)
      redirect_to users_path
    else
      redirect_to edit_user_path
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    redirect_to users_path
  end

  def lock
    user = User.find(params[:id])
    user.lock_access! if !(current_user == user)
    redirect_to users_path
  end

  def unlock
    user = User.find(params[:id])
    user.unlock_access! if !(current_user == user)
    redirect_to users_path
  end

  private

  def user_params
    params.require(:user).
      permit(:email, :password, :password_confirmation, :names, :father_last_name, :mother_last_name)
  end

  def allow_without_password
    if params[:user][:password].blank? && params[:user][:password_confirmation].blank?
      params[:user].delete(:password)
      params[:user].delete(:password_confirmation)
    end
  end

  def lock_access!
    self.locked_at = Time.now.utc
  end

  def unlock_access!
    self.locked_at = nil
  end

end
