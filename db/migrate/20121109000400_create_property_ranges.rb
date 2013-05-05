class CreatePropertyRanges < ActiveRecord::Migration
  def change
    create_table :property_ranges do |t|
      t.references :property
      t.references :profile
      t.string :value_type
      t.text :exact_value
      t.text :min_value
      t.text :max_value
      t.string :constraint_type # MANDATORY/DESIRABLE

      t.timestamps
    end
  end
end
