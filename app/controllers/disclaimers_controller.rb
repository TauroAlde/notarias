class DisclaimersController < ApplicationController
  skip_before_filter :authenticate_user!, only: [:index]

  def index
  end

  def new
  end

  def update
    current_user.accept_disclaimer
    redirect_to root_path
  end
end
