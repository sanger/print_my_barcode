class CreateDrawings < ActiveRecord::Migration
  def change
    create_table :drawings do |t|
      t.string :x_origin
      t.string :y_origin
      t.string :field_name
      t.integer :placeholder_id
      t.text :options
      t.references :label, index: true, foreign_key: true
      t.string :type

      t.timestamps null: false
    end
  end
end
