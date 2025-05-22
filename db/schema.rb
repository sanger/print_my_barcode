# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2021_08_11_114323) do
  create_table "drawings", force: :cascade do |t|
    t.string "x_origin"
    t.string "y_origin"
    t.string "field_name"
    t.integer "placeholder_id"
    t.text "options"
    t.integer "label_id"
    t.string "type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["label_id"], name: "index_drawings_on_label_id"
  end

  create_table "label_templates", force: :cascade do |t|
    t.string "name"
    t.integer "label_type_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["label_type_id"], name: "index_label_templates_on_label_type_id"
    t.index ["name"], name: "index_label_templates_on_name", unique: true
  end

  create_table "label_types", force: :cascade do |t|
    t.string "pitch_length"
    t.string "print_width"
    t.string "print_length"
    t.string "feed_value"
    t.string "fine_adjustment"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_label_types_on_name", unique: true
  end

  create_table "labels", force: :cascade do |t|
    t.string "name"
    t.integer "label_template_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["label_template_id"], name: "index_labels_on_label_template_id"
  end

  create_table "printers", force: :cascade do |t|
    t.string "name"
    t.integer "protocol", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "printer_type"
    t.index ["name"], name: "index_printers_on_name", unique: true
  end
end
