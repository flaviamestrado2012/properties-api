class ProfilesController < ApplicationController

  def index
    @profiles = Profile.all
  end
  
  def show
    @profile = Profile.find(params[:id])
  end    
  
  def new
    @profile = Profile.new
    
    @inserted_properties = {}

    @profile.property_ranges.each do |pr|
      @inserted_properties[pr.property] = {
        :exact => pr.exact_value, 
        :min => pr.min_value,
        :max => pr.max_value
      }
    end

    @available_properties = get_available_properties

  end 
    
  def create
    @profile = Profile.new(params[:profile])
    @inserted_properties = params[:insertedProperties]
    
    if @profile.save
      save_property_ranges

      flash[:notice] = "Profile has been created."
      redirect_to profiles_path
    else
      normalize_inserted_properties
      
      @available_properties = get_available_properties

      flash[:alert] = "Profile has not been created."
      render :action => "new"
    end
  end
  
  def edit
    @profile = Profile.find(params[:id])

    @inserted_properties = {}
  
    @profile.property_ranges.each do |pr|
      @inserted_properties[pr.property] = {
        :exact => pr.exact_value, 
        :min => pr.min_value,
        :max => pr.max_value
      }
    end

    @available_properties = get_available_properties
  end
  
  def update        
    @profile = Profile.find(params[:id])
    @inserted_properties = params[:insertedProperties]
        
    if @profile.update_attributes(params[:profile])
      save_property_ranges

      flash[:notice] = "Profile has been updated"
      redirect_to profiles_path
    else
      normalize_inserted_properties
      
      @available_properties = get_available_properties

      flash[:alert] = "Profile has not been updated"
      render :action => "edit"
    end
  end   
  
  def destroy
    @profile = Profile.find(params[:id])
    
    @profile.destroy
    flash[:notice] = "Profile has been deleted."
    redirect_to profiles_path
  end

  private

  def save_property_ranges
    @profile.property_ranges.destroy_all

    if @inserted_properties
    
      @inserted_properties.keys.each do |key|
          
        current_property = Property.find(key)
        
        if current_property          

          current_property_range = PropertyRange.new          

          case current_property.value_type
          when 'Numeric'
            value_exact = @inserted_properties[key][:exact].to_f if @inserted_properties[key][:exact] != ''
            value_min = @inserted_properties[key][:min].to_f if @inserted_properties[key][:min] != ''
            value_max = @inserted_properties[key][:max].to_f if @inserted_properties[key][:max] != ''
          else
            value_exact = @inserted_properties[key][:exact]
            value_min = @inserted_properties[key][:min]
            value_max = @inserted_properties[key][:max]
          end

          puts "Value exact: #{value_exact}"
          puts "Value min: #{value_min}"
          puts "Value max: #{value_max}"
          
          current_property_range.exact_value = value_exact
          current_property_range.min_value = value_min
          current_property_range.max_value = value_max
          current_property_range.value_type = current_property.value_type
          current_property_range.property = current_property
          current_property_range.save

          current_property.property_ranges.push current_property_range
          @profile.property_ranges.push current_property_range
        end        

      end
    end
  end

  def normalize_inserted_properties
    if @inserted_properties
      new_inserted_properties = {}

      @inserted_properties.keys.each do |key|        
        new_inserted_properties[Property.find(key)] = @inserted_properties[key]
      end

      @inserted_properties = new_inserted_properties
    else
      @inserted_properties = {}
    end
  end

  def get_available_properties
    if @inserted_properties and @inserted_properties.any?
      Property.where('id NOT IN (?)', @inserted_properties.keys.map { |p| p.id } )
    else
      Property.all
    end
  end


end
