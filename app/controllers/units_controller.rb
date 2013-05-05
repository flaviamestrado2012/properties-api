class UnitsController < ApplicationController

  def index
    @units = Unit.all
  end
  
  def show
    @unit = Unit.find(params[:id])
  end    
  
  def new
    @unit = Unit.new    
  end 
    
  def create
    @unit = Unit.new(params[:unit])
    
    if @unit.save
      flash[:notice] = "Unit has been created."
      redirect_to units_path
    else
      flash[:alert] = "Unit has not been created."
      render :action => "new"
    end
  end
  
  def edit
    @unit = Unit.find(params[:id])
  end
  
  def update        
    @unit = Unit.find(params[:id])
        
    if @unit.update_attributes(params[:unit])
      flash[:notice] = "Unit has been updated"
      redirect_to units_path
    else
      flash[:alert] = "Unit has not been updated"
      render :action => "edit"
    end
  end   
  
  def destroy
    @unit = Unit.find(params[:id])
    
    @unit.destroy
    flash[:notice] = "Unit has been deleted."
    redirect_to units_path
  end

end
