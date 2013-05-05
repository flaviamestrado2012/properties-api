class Unit < ActiveRecord::Base
  attr_accessible :name

  has_many :properties, :dependent => :destroy

  # validations
  validates :name, :presence => true, :uniqueness => true

    # exclude fields from json output
  def as_json(options={})
    options[:except] ||= [:created_at, :updated_at]
    super(options)
  end 
end
