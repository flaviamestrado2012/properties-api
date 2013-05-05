class CreateProperties < ActiveRecord::Migration
  def change
    create_table :properties do |t|
      t.string :name
      t.text :description
      t.string :value_type
      t.references :unit

      t.timestamps
    end
  end
end
