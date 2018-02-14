class PreferencesController < ApplicationController

  def index
    @preferences = current_user.preferences
  end

  def show
    @preference = Preference.find(params[:id])
  end

  def new
    @preference = Preference.new
  end

  def edit
    @preference = Preference.find(params[:id])
  end

  def create
    preference = Preference.new(preference_params)
    if preference.save
      redirect_to preferences_path
    else
      redirect_to new_user_path
    end
  end

  def update
    @preference = Preference.find(params[:id])
    
    if @preference.update(preference_params)
      redirect_to preferences_path
    else
      redirect_to edit_preference_path
    end
  end

  def destroy
    @preference = Preference.find(params[:id])
    @preference.destroy
    redirect_to preferences_path
  end

  private

  def preference_params
    params.require(:preference).
      permit(:name, :description, :default_values, :encryted, :field)    
  end

end
