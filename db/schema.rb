# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2018_07_04_105517) do

  create_table "concordances", force: :cascade do |t|
    t.integer "nr"
    t.string "ccd0"
    t.string "ccd1"
    t.string "ccd2"
    t.string "comment"
    t.string "composer"
    t.string "title"
    t.integer "piece_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["piece_id"], name: "index_concordances_on_piece_id"
  end

  create_table "parts", force: :cascade do |t|
    t.integer "nr"
    t.string "part_nr"
    t.string "part_fol"
    t.string "title"
    t.string "composer"
    t.string "textincipit"
    t.string "voicesincipit"
    t.integer "piece_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["piece_id"], name: "index_parts_on_piece_id"
  end

  create_table "pieces", force: :cascade do |t|
    t.integer "nr"
    t.string "cs"
    t.integer "current"
    t.string "original"
    t.string "fol"
    t.string "title"
    t.string "title0"
    t.string "composer"
    t.integer "code_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["code_id"], name: "index_pieces_on_code_id"
  end

  create_table "units", force: :cascade do |t|
    t.string "type"
    t.string "material"
    t.string "comment0"
    t.string "cs"
    t.string "comment1"
    t.string "pages"
    t.string "comment2"
    t.string "unit_nr"
    t.string "comment3"
    t.string "non0"
    t.string "comment4"
    t.string "comment5"
    t.string "owner"
    t.string "non1"
    t.string "size"
    t.string "non2"
    t.string "non3"
    t.string "color0"
    t.string "color1"
    t.string "color2"
    t.string "color3"
    t.string "comment6"
    t.integer "code_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["code_id"], name: "index_units_on_code_id"
  end

end
