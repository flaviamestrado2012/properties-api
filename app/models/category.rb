class Category < ActiveRecord::Base
  attr_accessible :name, :description, :parent, :children, :items, :parent_id
  
  has_many :children, :class_name => "Category", :foreign_key => "parent_id", :dependent => :nullify
  belongs_to :parent, :class_name => "Category"
   
  has_many :categorizations
  has_many :items, :through => :categorizations

  # validations
  validates :name, :presence => true, :uniqueness => true
  
  def all_children(children_array = [], name_filter = '', rules_filter)

    if name_filter.to_s == ''
      child_categories = Category.where(:parent_id => self.id).includes(:items)
    else      
      child_categories = Category.where(:parent_id => self.id).includes(:items).where("lower(items.name) like ?", "%#{name_filter.downcase}%")
    end
    
    children_array += child_categories.all
    child_categories.each do |child|      
      children_array = child.all_children(children_array, name_filter)
    end

    children_array    
  end

  def as_json(options={})
    options[:except] ||= [:created_at, :updated_at]
    super(options)
  end 



  def all_items(children_array = [], items_list = [], name_filter = '')
    puts "name_filter: #{name_filter}" 


    @child_items = []
    child_categories = Category.where(:parent_id => self.id)

    #puts "=============child_categories============="
    #puts child_categories.inspect

    child_categories.each do |child_category|
      if name_filter.to_s == ''        
        @child_items = child_category.items
      else        
        @child_items = child_category.items.where("lower(items.name) like ?", "%#{name_filter.downcase}%")
      end

      #puts "=============child_items============="
      #puts @child_items.inspect
      
      # add child items to list
      @child_items.each do |item|
         items_list << item unless items_list.include?(item)
      end
    end    

    #puts "=============items_list============="
    #puts items_list.inspect

    children_array += child_categories.all
    
    child_categories.each do |child|
      items_list = child.all_items(children_array, items_list, name_filter)      
    end                        

    items_list    
  end

  def as_json(options={})
    options[:except] ||= [:created_at, :updated_at]
    super(options)
  end 
end
