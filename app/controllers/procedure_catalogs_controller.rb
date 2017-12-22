class ProcedureCatalogsController < ApplicationController

  def index
    @procedure = Procedure.all.order(:id)
  end

  def show
    @procedure = Procedure.find(params[:id])
  end

  def new
    @procedure = Procedure.new 
  end
end
