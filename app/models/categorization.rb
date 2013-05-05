class Categorization < ActiveRecord::Base
  attr_accessible :category, :item
  
  belongs_to :category
  belongs_to :item
  
end
