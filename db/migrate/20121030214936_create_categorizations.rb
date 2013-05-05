class CreateCategorizations < ActiveRecord::Migration
  def change
    create_table :categorizations do |t|
      t.references :category
      t.references :item  
      t.timestamps
    end
  end
end
