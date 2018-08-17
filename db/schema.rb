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

ActiveRecord::Schema.define(version: 2018_07_31_000001) do

  create_table "codes", id: false, force: :cascade do |t|
    t.integer "cs"
    t.string "non10"
    t.string "content"
    t.string "t_"
    t.string "material"
    t.string "n_"
    t.string "size"
    t.string "place"
    t.string "date"
    t.string "owner0"
    t.text "title_comment"
    t.text "binding_comment"
    t.string "pagenumbering"
    t.text "non0"
    t.text "non4"
    t.text "comment0"
    t.text "non1"
    t.text "non2"
    t.text "comment1"
    t.string "non11"
    t.string "notation"
    t.string "non3"
    t.string "owner1"
    t.string "non12"
    t.string "non5"
    t.string "non13"
    t.string "non6"
    t.text "comment2"
    t.string "non7"
    t.string "libsig"
    t.text "lit"
    t.string "non14"
    t.string "non8"
    t.string "sig0"
    t.string "non15"
    t.string "non9"
    t.string "sig1"
    t.string "sig2"
    t.text "comment3"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "concordances", force: :cascade do |t|
    t.integer "nr"
    t.string "ccd0"
    t.string "ccd1"
    t.string "ccd2"
    t.text "comment"
    t.string "composer"
    t.string "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "parts", force: :cascade do |t|
    t.integer "nr"
    t.string "part_nr"
    t.string "part_fol"
    t.string "title"
    t.string "composer"
    t.string "textincipit"
    t.string "voices"
    t.string "comment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "pieces", force: :cascade do |t|
    t.string "non0"
    t.string "non1"
    t.integer "cs"
    t.string "lit"
    t.string "non2"
    t.string "pages"
    t.string "t_"
    t.string "non3"
    t.integer "current"
    t.string "title"
    t.string "non4"
    t.integer "nr"
    t.string "non5"
    t.integer "nr0"
    t.string "title0"
    t.string "title1"
    t.string "title2"
    t.string "composer"
    t.string "composer0"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "units", force: :cascade do |t|
    t.string "t_"
    t.string "material"
    t.string "comment0"
    t.integer "cs"
    t.string "comment1"
    t.string "pages"
    t.string "comment2"
    t.integer "unit_nr"
    t.string "comment3"
    t.string "notation"
    t.string "non0"
    t.string "comment5"
    t.string "comment6"
    t.string "comment7"
    t.string "owner"
    t.string "non1"
    t.string "size"
    t.string "non2"
    t.string "color0"
    t.string "color1"
    t.string "color2"
    t.string "color3"
    t.string "non3"
    t.string "comment8"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
