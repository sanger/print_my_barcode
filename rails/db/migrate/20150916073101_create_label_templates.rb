class CreateLabelTemplates < ActiveRecord::Migration
  def change
    create_table :label_templates do |t|
      t.references :label_type, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
