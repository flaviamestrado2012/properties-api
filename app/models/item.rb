class Item < ActiveRecord::Base
  attr_accessible :name, :description, :property_valuations, :barcode
  
  has_many :property_valuations, :dependent => :destroy
  has_many :properties, :through => :property_valuations 

  has_many :categorizations
  has_many :categories, :through => :categorizations

  # validations
  validates :name, :presence => true, :uniqueness => true
  validates :barcode, :uniqueness => true, :allow_nil => true, :allow_blank => true

  def as_json(options={})
    options[:except] ||= [:created_at, :updated_at]  
    #options[:include] ||= [:property_valuations]    
    super(options)
  end 

end
