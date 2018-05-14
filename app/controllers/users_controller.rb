class UsersController < ApplicationController
  respond_to :html, :json

  before_action :set_default_load_scope, except: [:load_current_user]
  before_action :allow_without_password, only: [:update]
  before_action :load_segment, except: [:load_current_user]
  before_action :load_users, only: [:index, :create, :update]
  before_action :load_search, only: [:index, :create, :update]

  def index
    @user = User.find(params[:user_id]) if params[:user_id]
  end

  def show
    @user = User.unscoped.find(params[:id])
    authorize! :manage, @user
    #@groups = @user.groups
  end

  def new
    @user = User.new
    authorize! :manage, @segment
  end

  def edit
    @user = User.unscoped.find(params[:id])
    authorize! :manage, @user
  end

  def create
    @user = User.new user_params
    authorize! :manage, @segment
    begin
      @user.save!
      @user.segments << @segment if @segment
      @user.roles << Role.common
    rescue ActiveRecord::RecordNotUnique => e
      @user.user_groups.each do |ug|
        ug.errors.add(:group_id, t(:cant_send_duplicates)) if ug.new_record?
      end
      flash[:error] = t(:errors_creating_the_user)
    rescue ActiveRecord::RecordInvalid => e
      flash[:error] = t(:errors_creating_the_user)
    end
    flash[:notice] = t(:success_user_create) if flash[:error].blank? && @user.errors.empty?
    render :index
  end

  def update
    @user = User.unscoped.find(params[:id])
    authorize! :manage, @user
    begin
      @user.update(user_params)
    rescue ActiveRecord::RecordNotUnique => e
      @user.user_groups.each do |ug|
        ug.errors.add(:group_id, t(:cant_send_duplicates)) if ug.new_record?
      end
      flash[:error] = t(:errors_updating_the_user)
    rescue ActiveRecord::RecordInvalid => e
      flash[:error] = t(:errors_updating_the_user)
    end
    flash[:notice] = t(:success_user_update) if flash[:error].blank? && @user.errors.empty?
    render :index 
  end

  def destroy
    @user = User.find(params[:id])
    authorize! :manage, @user
    @user.lock_access!
    @user.destroy
    flash[:notice] = t(:deleted_users_successfully)
    redirect_to users_path
  end

  def lock
    @user = User.find(params[:id])
    authorize! :manage, @user
    if !(current_user == @user)
      @user.lock_access!
      @user.destroy
      flash[:success] = t(:lock_access)
    else
      flash[:notice] = t(:cant_perform_this_action)
    end
    redirect_to segment_users_path(@segment)
  end

  def unlock
    @user = User.unscoped.find(params[:id])
    authorize! :unlock, @user
    if !(current_user == @user)
      @user.unlock_access!
      @user.restore
      flash[:success] = t(:unlock_access)
    end
    redirect_to segment_users_path(@segment)
  end

  def load_current_user
    respond_with current_user.as_json(methods: :full_name)
  end

  private

  def load_users
    @users = if @segment
      load_segment_users
    elsif current_user.representative?
      segments_ids = current_user.represented_segments_and_descendant_ids
      User.unscoped.joins(:user_segments).where(user_segments: { segment_id: segments_ids })
    elsif current_user.admin? || current_user.super_admin?
      User.unscoped
    end
  end

  def load_segment_users
    User.unscoped.joins(:user_segments).where(user_segments: { segment_id: @segment.id })
  end

  def load_search
    @q = @users.ransack(params[:q])
    @users = @q.result(distinct: true).paginate(page: params[:page], per_page: 20)
  end

  def load_segment
    @segment = Segment.find(params[:segment_id])
  end

  def user_params
    params.require(:user).
      permit(:username, :email, :password, :password_confirmation, :name, :father_last_name, :mother_last_name, 
              user_groups_attributes: [:id, :user_id, :group_id, :_destroy])
  end

  def allow_without_password
    if params[:user][:password].blank? && params[:user][:password_confirmation].blank?
      params[:user].delete(:password)
      params[:user].delete(:password_confirmation)
    end
  end

  def set_default_load_scope
    params[:q] = {} if params[:q].nil?
    params[:q].merge!({ deleted_at_null: 1 }) unless (params[:q].keys.map(&:to_sym) & [:deleted_at_null, :deleted_at_not_null]).any?
  end
end
