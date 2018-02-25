class ApplicationController < ActionController::Base
  before_action :authenticate_user!, :configure_permitted_parameters
  protect_from_forgery with: :exception

  before_action :set_locale
  before_action :masquerade_user!

  def default_url_options
    { locale: I18n.locale }
  end

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  protected

  def configure_permitted_parameters
    added_attrs = [:username, :email, :password, :password_confirmation, :remember_me]
    devise_parameter_sanitizer.permit :sign_up, keys: added_attrs
    devise_parameter_sanitizer.permit :account_update, keys: added_attrs
  end

  def authorize!(resource)
    binding.pry
  end
end
