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

ActiveRecord::Schema.define(version: 2021_11_25_004006) do

  create_table "genres", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "platforms", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "product_genres", force: :cascade do |t|
    t.integer "genre_id", null: false
    t.integer "product_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["genre_id"], name: "index_product_genres_on_genre_id"
    t.index ["product_id"], name: "index_product_genres_on_product_id"
  end

  create_table "product_platforms", force: :cascade do |t|
    t.integer "platform_id", null: false
    t.integer "product_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["platform_id"], name: "index_product_platforms_on_platform_id"
    t.index ["product_id"], name: "index_product_platforms_on_product_id"
  end

  create_table "products", force: :cascade do |t|
    t.string "name"
    t.integer "game_id"
    t.decimal "general_rating"
    t.decimal "metacritic_rating"
    t.string "esrb_rating"
    t.string "image"
    t.string "release_date"
    t.integer "publisher_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["publisher_id"], name: "index_products_on_publisher_id"
  end

  create_table "publishers", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  add_foreign_key "product_genres", "genres"
  add_foreign_key "product_genres", "products"
  add_foreign_key "product_platforms", "platforms"
  add_foreign_key "product_platforms", "products"
  add_foreign_key "products", "publishers"
end
