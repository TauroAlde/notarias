class UsersImportsController < ApplicationController
  def new
  end

  def create
    @user_import = UserImportManager.new(
      file: import_user_params[:import_users],
      status: SegmentUserImport.statuses["incomplete"]
    )
    @user_import.save
  end

  private

  def import_user_params
    params.require(:import_file).permit(:import_users)
  end
end
