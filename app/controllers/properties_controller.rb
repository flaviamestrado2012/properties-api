class PropertiesController < ApplicationController
  
  def index
    @properties = Property.all
  end
  
  def show
    @property = Property.find(params[:id])
  end    
  
  def new
    @property = Property.new    
    @possible_types = %w[Numeric Text]
  end 
    
  def create
    @property = Property.new(params[:property])
    @possible_types = %w[Numeric Text]
    if @property.save
      flash[:notice] = "Property has been created."
      redirect_to properties_path
    else
      flash[:alert] = "Property has not been created."
      render :action => "new"
    end
  end
  
  def edit
    @property = Property.find(params[:id])
    @possible_types = %w[Numeric Text]
  end
  
  def update        
    @property = Property.find(params[:id])
    @possible_types = %w[Numeric Text]
        
    if @property.update_attributes(params[:property])
      flash[:notice] = "Property has been updated"
      redirect_to properties_path
    else
      flash[:alert] = "Property has not been updated"
      render :action => "edit"
    end
  end   
  
  def destroy
    @property = Property.find(params[:id])
    
    @property.destroy
    flash[:notice] = "Property has been deleted."
    redirect_to properties_path
  end
  
end
