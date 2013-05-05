class PropertyRange < ActiveRecord::Base
  attr_accessible :property, :exact_value, :min_value, :max_value, :constraint_type, :value_type

  belongs_to :property
  belongs_to :profile

  def as_json(options={})
    options[:except] ||= [:created_at, :updated_at]
    options[:include] ||= [:property]
    super(options)
  end 

end
