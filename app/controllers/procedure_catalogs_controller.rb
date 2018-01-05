class ProcedureCatalogsController < ApplicationController

  def index
    @procedures = Procedure.all
  end

  def show
    @procedure = Procedure.find(params[:id])
  end

  def new
    @procedure = Procedure.new 
  end

  def create
    @procedure = Procedure.new(procedure_params)
    if @procedure.save
      redirect_to procedure_catalogs_path
    else
      redirect_to :new
    end
  end

  def edit
    @procedure = Procedure.find(params[:id])
  end

  def update
    @procedure = Procedure.find(params[:id])
    if @procedure.update_attributes(procedure_params)
      redirect_to procedure_catalog_path(@procedure)
    else
      render :edit
    end
  end

  def destroy
    @procedure = Procedure.find(params[:id])
    @procedure.destroy
    redirect_to procedure_catalogs_path
  end
  private

  def procedure_params
    params.require(:procedure).permit(:name, :creator_user_id, :version)
  end
end
