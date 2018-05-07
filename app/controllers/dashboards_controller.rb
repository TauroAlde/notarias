class DashboardsController < ApplicationController
  before_action :autorize_manage_dashboard

  def index
  end

  private

  def autorize_manage_dashboard
    authorize! :manage, :dashboard
  end
end
