class PropertyValuation < ActiveRecord::Base
      
  attr_accessible :property, :item, :value, :categorization
      
  belongs_to :property
  belongs_to :item

  def as_json(options={})
    options[:except] ||= [:created_at, :updated_at]      
    super(options)
  end 
     
end
