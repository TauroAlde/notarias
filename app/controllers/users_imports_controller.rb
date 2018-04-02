class UsersImportsController < ApplicationController
  def new
  end

  def create
    @user_import = SegmentUserImport.new(
      file: import_user_params[:import_users],
      status: SegmentUserImport.statuses["incomplete"]
    )
    @user_import.save
    begin
      User.transaction do
        @import = UserImportManager.new(user_import_id)
        @import.import
      end
    rescue Exception => exeption_msgs
      @user_import = SegmentUserImport.find(user_import_id)
      @user_import.update_attributes(status: SegmentUserImport.statuses["failed"])
    end
  end

  private

  def import_user_params
    params.require(:import_file).permit(:import_users)
  end
end
