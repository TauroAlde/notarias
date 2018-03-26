class UsersBatchActionsController < ApplicationController
  def create
    @users = User.where(id: params[:users_ids])
    run_batch_action
  end

  def run_batch_action
    @users_with_errors = []
    User.transaction do
      send(params[:batch_action])
      @users.first.errors.add(:name)
      @users.each do |user|
        @users_with_errors << user if !user.errors.empty?
      end
      set_action_message
      raise ActiveRecord::Rollback, "Call tech support!" if @users_with_errors.present?
    end
  end

  def delete
    @users.destroy_all
  end

  def set_action_message
    @action_message = case params[:batch_action]
                      when 'delete'
                        @users_with_errors.empty? ?
                          t(:deleted_users_successfully) :
                          t(:failed_to_delete_users, users: @users_with_errors.map(&:name).join(', '))
                      end
  end
end
