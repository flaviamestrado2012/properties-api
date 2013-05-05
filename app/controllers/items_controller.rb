class ItemsController < ApplicationController
  
  def save_item_properties
    @item.property_valuations.destroy_all

    if @inserted_properties
    
      @inserted_properties.keys.each do |key|              

        current_property = Property.find(key)
        
        if current_property
          @item.properties.push(current_property)  
          current_property_valuation = PropertyValuation.where('item_id = ? AND property_id = ?', @item.id, current_property.id).first
          current_property_valuation.value = @inserted_properties[key]
          current_property_valuation.save
        end
      end
    end
  end

  def get_available_properties
    if @inserted_properties and @inserted_properties.any?
     Property.where('id NOT IN (?)', @inserted_properties.keys.map { |p| p.id } )
    else
      Property.all
    end
  end

  def normalize_inserted_properties
    if @inserted_properties
      @new_inserted_properties = {}

      @inserted_properties.keys.each do |key|        
        @new_inserted_properties[Property.find(key)] = @inserted_properties[key]
      end

      @inserted_properties = @new_inserted_properties
    else
      @inserted_properties = {}
    end
  end

  def get_available_categories
    if @inserted_categories and @inserted_categories.any?
      Category.where('id NOT IN (?)', @inserted_categories)
    else
      Category.all
    end
  end

  def normalize_inserted_categories
    if @inserted_categories
      @new_inserted_categories = []

      @inserted_categories.each do |id|        
        @new_inserted_categories.push Category.find(id)
      end

      @inserted_categories = @new_inserted_categories
    else
      @inserted_categories = []
    end
  end

  def save_item_categories
    @item.categories.destroy_all

    if @inserted_categories
    
      @inserted_categories.each do |id|          
        current_category = Category.find(id)       
        if current_category 
          @item.categories.push(current_category)        
        end
      end
    end
  end

  def index
    @items = Item.all
  end

  def show
    @item = Item.find(params[:id])
  end

  def new
    @item = Item.new
    @inserted_properties = {}
    @inserted_categories = []

    @item.property_valuations.each do |pv|
      @inserted_properties[pv.property_id] = pv.value
    end

    @available_properties = get_available_properties
    @available_categories = get_available_categories
  end

  def create
    @item = Item.new(params[:item])
    @inserted_properties = params[:insertedProperties]
    @inserted_categories = params[:insertedCategories]

    if @item.save 
      save_item_properties
      save_item_categories

      flash[:notice] = "Item has been created."
      redirect_to items_path
    else       

      normalize_inserted_properties
      normalize_inserted_categories

      @available_properties = get_available_properties
      @available_categories = get_available_categories

      flash[:alert] = "Item has not been created."
      render :action => "new"
    end
  end

  def edit
    @item = Item.find(params[:id])
    
    @inserted_properties = {}
    @inserted_categories = []
    
    @item.property_valuations.each do |pv|
      @inserted_properties[pv.property] = pv.value
    end

    @item.categories.each do |category|
      @inserted_categories.push category
    end

    @available_properties = get_available_properties 
    @available_categories = get_available_categories   
  end

  def update
    @item = Item.find(params[:id])
    @inserted_properties = params[:insertedProperties]
    @inserted_categories = params[:insertedCategories]

    if @item.update_attributes(params[:item])
      
      save_item_properties
      save_item_categories

      flash[:notice] = "Item has been updated"
      redirect_to items_path
    else

      normalize_inserted_properties
      normalize_inserted_categories

      @available_properties = get_available_properties
      @available_categories = get_available_categories

      flash[:alert] = "Item has not been updated"
      render :action => "new"
    end
  end

  def destroy
    @item = Item.find(params[:id])

    @item.destroy
    flash[:notice] = "Item has been deleted."
    redirect_to items_path
  end
end