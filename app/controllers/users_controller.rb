class UsersController < ApplicationController

  before_action :set_default_load_scope, only: [:index]
  before_action :allow_without_password, only: [:update]
  #before_action :authorize!
  before_action :load_groups
  before_action :load_search
  before_action :load_users
  before_action :load_segment
  authorize_resource

  def index
  end

  def show
    @user = User.unscoped.find(params[:id])
    @groups = @user.groups
  end

  def new
    @user = User.new
  end

  def edit
    @user = User.unscoped.find(params[:id])
  end

  def create
    begin
      @user = User.create!(user_params)
      @user.roles << Role.common
    rescue ActiveRecord::RecordNotUnique => e
      @user.user_groups.each do |ug|
        ug.errors.add(:group_id, t(:cant_send_duplicates)) if ug.new_record?
      end
      flash[:error] = t(:errors_creating_the_user)
    end
    flash[:notice] = t(:success_user_create) if flash[:error].blank? && @user.errors.empty?
    render :index
  end

  def update
    @user = User.unscoped.find(params[:id])
    begin
      @user.update(user_params)
    rescue ActiveRecord::RecordNotUnique => e
      @user.user_groups.each do |ug|
        ug.errors.add(:group_id, t(:cant_send_duplicates)) if ug.new_record?
      end
      flash[:error] = t(:errors_updating_the_user)
    end
    flash[:notice] = t(:success_user_update) if flash[:error].blank? && @user.errors.empty?
    render :index 
  end

  def destroy
    @user = User.find(params[:id])
    @user.lock_access!
    @user.destroy
    flash[:notice] = t(:deleted_users_successfully)
    redirect_to users_path
  end

  def lock
    @user = User.find(params[:id])
    if !(current_user == @user)
      @user.lock_access!
      @user.destroy
      flash[:success] = t(:lock_access)
    else
      flash[:notice] = t(:cant_perform_this_action)
    end
    redirect_to users_path
  end

  def unlock
    @user = User.unscoped.find(params[:id])
    if !(current_user == @user)
      @user.unlock_access!
      @user.restore
      flash[:success] = t(:unlock_access)
    else
      flash[:alert] = t(:cant_perform_this_action)
    end
    redirect_to users_path
  end

  private

  def load_users
    @users = @q
      .result(distinct: true).paginate(page: params[:page], per_page: 20)
      #.where('id NOT in (?)', [current_user.id])
    @users = if current_user.super_admin? || current_user.admin?
      @users
    elsif current_user.represented_segments.present?
      segments_ids = current_user.represented_segments_and_descendant_ids
      @users.joins(:user_segments)
        .where(user_segments: { segment_id: segments_ids })
    else
      flash[:alert] = t(:cant_perform_this_action)
      redirect_to root_path
    end
  end

  def load_groups
    @groups = Group.all
  end

  def load_search
    @q = User.unscoped.ransack(params[:q])
  end

  def load_segment
    @segment = Segment.find(params[:segment_id]) if params[:segment_id]
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
    params[:q] = { deleted_at_null: 1 } unless params[:q]
  end
end
