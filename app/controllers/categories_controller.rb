class CategoriesController < ApplicationController
  
  def index
    @categories = Category.all
  end

  def show
    @category = Category.find(params[:id])
  end

  def new
    @category = Category.new
    @available_categories = Category.all;
  end

  def create
    @category = Category.new(params[:category])
    @available_categories = Category.all;

    if @category.save
      flash[:notice] = "Category has been created."
      redirect_to categories_path
    else
      flash[:alert] = "Category has not been created."
      render :action => "new"
    end
  end

  def edit
    @category = Category.find(params[:id])    
    @available_categories = Category.where('id <> ?', params[:id]);
  end

  def update
    @category = Category.find(params[:id])
    @available_categories = Category.where('id <> ?', params[:id]);

    if @category.update_attributes(params[:category])
      flash[:notice] = "Category has been updated"
      redirect_to categories_path
    else
      flash[:alert] = "Category has not been updated"
      render :action => "new"
    end

  end

  def destroy
    @category = Category.find(params[:id])

    @category.destroy
    flash[:notice] = "Item has been deleted."
    redirect_to categories_path
  end
  
end
