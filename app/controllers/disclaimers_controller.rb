class DisclaimersController < ApplicationController
  def new
  end

  def update
    current_user.accept_disclaimer
    redirect_to root_path
  end
end
