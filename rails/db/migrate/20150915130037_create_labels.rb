class CreateLabels < ActiveRecord::Migration
  def change
    create_table :labels do |t|
      t.string :name
      t.references :label_template, index: true, foreign_key: true
      t.timestamps null: false
    end
  end
end
