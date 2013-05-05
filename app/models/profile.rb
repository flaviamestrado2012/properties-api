class Profile < ActiveRecord::Base
  # attr_accessible :title, :body
  attr_accessible :name, :description

  has_many :property_ranges, :dependent => :destroy

  # validations
  validates :name, :presence => true, :uniqueness => true

  def as_json(options={})
    options[:except] ||= [:created_at, :updated_at]
    super(options)
  end 

end