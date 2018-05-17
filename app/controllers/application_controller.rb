class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?
  protect_from_forgery with: :exception

  before_action :set_locale
  before_action :masquerade_user!
  before_action :validate_common_user?

  #rescue_from Authorizer::AccessDenied do |exception|
  #  redirect_to root_path, flash: { alert: exception.message }
  #end

  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.html { redirect_to main_app.root_url, alert: exception.message }
      format.js   { head :forbidden, content_type: 'text/html' }
    end
  end

  def default_url_options
    { locale: I18n.locale }
  end

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def validate_common_user?
    if current_user && current_user.only_common? && !current_user.incomplete_prep_processes.empty? && !allowed_common_user_controllers?
      redirect_to new_segment_prep_process_path(root_segment)
    end
  end

  def root_segment
    if current_user.representative?
      current_user.represented_segments.first
    elsif current_user.admin? || current_user.super_admin?
      Segment.root
    elsif current_user.common?
      current_user.segments.last || Segment.root
    end
  end

  def allowed_common_user_controllers?
    prep_process_controller? || profiles_controller? || devise_controller? || messages_controllers?
  end

  def prep_process_controller?
    self.class == PrepProcessesController ||
      self.class == PrepStepTwosController ||
      self.class == PrepStepThreesController ||
      self.class == PrepStepFoursController
  end

  def profiles_controller?
    self.class == ProfilesController
  end

  def messages_controllers?
    self.class == SegmentMessagesController ||
      self.class == MessagesKpisController ||
      self.class == UserMessagesController ||
      self.class == SegmentMessages::ResponsesController ||
      self.class == UserMessages::ResponsesController ||
      self.class == ChatSearchesController ||
      self.class == UsersController
  end

  protected

  def configure_permitted_parameters
    added_attrs = [:username, :email, :password, :password_confirmation, :remember_me]
    devise_parameter_sanitizer.permit :sign_up, keys: added_attrs
    devise_parameter_sanitizer.permit :account_update, keys: added_attrs
  end

  def access_denied(exception)
     redirect_to root_path, alert: exception.message
   end

  #def authorize!(resource = self.class, action: nil)
  #  Authorizer.new(current_user).authorize!(resource, action)
  #end
end
