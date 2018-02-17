class UserPreferencesController < ApplicationController
  
  def index
    @user_preferences = current_user.user_preferences
  end

  def show
    @user_preference = UserPreference.find(params[:id])
  end

  def new
    @user_preference = UserPreference.new
  end

  def edit
    @user_preference = UserPreference.find(params[:id])
  end

  def create
    user_preference = UserPreference.new(user_preference_params)
    if user_preference.save
      redirect_to user_preferences_path
    else
      redirect_to new_user_preference_path
    end
  end

  def update
    @user_preference = UserPreference.find(params[:id])
    
    if @user_preference.update(user_preference_params)
      redirect_to user_preferences_path
    else
      redirect_to edit_user_preference_path
    end
  end

  def destroy
    @user_preference = UserPreference.find(params[:id])
    @user_preference.destroy
    redirect_to user_preferences_path
  end

  private

  def user_preference_params
    params.require(:user_preference).
      permit(:user_id, :preference_id, :value)    
  end

end