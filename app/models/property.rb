class Property < ActiveRecord::Base
  attr_accessible :name, :description, :value_type, :unit, :unit_id
          
  has_many :property_valuations, :dependent => :destroy  
  has_many :items, :through => :property_valuations
  has_many :property_ranges, :dependent => :destroy

  belongs_to :unit
  
  # validations
  validates :name, :value_type, :unit, :presence => true
  validates :name, :uniqueness => true

  # exclude fields from json output

  def as_json(options={})
    options[:except] ||= [:created_at, :updated_at]
    options[:include] ||= [:unit]
    super(options)
  end 

  #def as_json(options={})
  #  {:id => self.id,
  #   :name => self.name,
  #   :description => self.description,
  #   :value_type => self.value_type,
  #   :unit_id => self.unit_id
  # }
  #end

end
