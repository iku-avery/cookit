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

ActiveRecord::Schema[7.0].define(version: 2024_12_13_212221) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_trgm"
  enable_extension "plpgsql"

  create_table "ingredients", force: :cascade do |t|
    t.string "name"
    t.decimal "amount"
    t.string "unit"
    t.string "remark"
    t.string "full_text"
    t.bigint "recipe_id", null: false
    t.bigint "product_ingredient_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["product_ingredient_id"], name: "index_ingredients_on_product_ingredient_id"
    t.index ["recipe_id"], name: "index_ingredients_on_recipe_id"
  end

  create_table "product_ingredients", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_product_ingredients_on_name", unique: true
    t.index ["name"], name: "index_product_ingredients_on_name_trigram", opclass: :gin_trgm_ops, using: :gin
  end

  create_table "recipes", force: :cascade do |t|
    t.string "title"
    t.string "author"
    t.decimal "rating"
    t.string "category"
    t.string "cuisine"
    t.integer "cook_time"
    t.integer "prep_time"
    t.string "image_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["title", "author"], name: "index_recipes_on_title_and_author", unique: true
  end

  add_foreign_key "ingredients", "product_ingredients"
  add_foreign_key "ingredients", "recipes"
end
