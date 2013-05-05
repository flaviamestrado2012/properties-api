class CreatePropertyValuations < ActiveRecord::Migration
  def change
    create_table :property_valuations do |t|
      t.references :item
      t.references :property
      t.text :value

      t.timestamps
    end
  end
end
