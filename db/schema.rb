# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20141029214152) do

  create_table "active_nutrition_migrations", force: true do |t|
    t.integer  "sequence_no"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "usda_food_groups", id: false, force: true do |t|
    t.integer  "code",        null: false
    t.string   "description", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "usda_foods", id: false, force: true do |t|
    t.integer  "nutrient_databank_number",            null: false
    t.integer  "food_group_code"
    t.string   "long_description",                    null: false
    t.string   "short_description",                   null: false
    t.string   "common_names"
    t.string   "manufacturer_name"
    t.boolean  "survey"
    t.string   "refuse_description"
    t.integer  "percentage_refuse"
    t.float    "nitrogen_factor",          limit: 24
    t.float    "protein_factor",           limit: 24
    t.float    "fat_factor",               limit: 24
    t.float    "carbohydrate_factor",      limit: 24
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "usda_foods_nutrients", force: true do |t|
    t.integer  "nutrient_databank_number",                null: false
    t.integer  "nutrient_number",                         null: false
    t.float    "nutrient_value",               limit: 24, null: false
    t.integer  "num_data_points",                         null: false
    t.float    "standard_error",               limit: 24
    t.string   "src_code",                                null: false
    t.string   "derivation_code"
    t.string   "ref_nutrient_databank_number"
    t.boolean  "add_nutrient_mark"
    t.integer  "num_studies"
    t.float    "min",                          limit: 24
    t.float    "max",                          limit: 24
    t.integer  "degrees_of_freedom"
    t.float    "lower_error_bound",            limit: 24
    t.float    "upper_error_bound",            limit: 24
    t.string   "statistical_comments"
    t.string   "add_mod_date"
    t.string   "confidence_code"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "usda_foods_nutrients", ["nutrient_databank_number", "nutrient_number"], name: "foods_nutrients_index", unique: true, using: :btree

  create_table "usda_foods_nutrients_copy", force: true do |t|
    t.string   "nutrient_databank_number",                null: false
    t.string   "nutrient_number",                         null: false
    t.float    "nutrient_value",               limit: 24, null: false
    t.integer  "num_data_points",                         null: false
    t.float    "standard_error",               limit: 24
    t.string   "src_code",                                null: false
    t.string   "derivation_code"
    t.string   "ref_nutrient_databank_number"
    t.boolean  "add_nutrient_mark"
    t.integer  "num_studies"
    t.float    "min",                          limit: 24
    t.float    "max",                          limit: 24
    t.integer  "degrees_of_freedom"
    t.float    "lower_error_bound",            limit: 24
    t.float    "upper_error_bound",            limit: 24
    t.string   "statistical_comments"
    t.string   "add_mod_date"
    t.string   "confidence_code"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "usda_foods_nutrients_copy", ["nutrient_databank_number", "nutrient_number"], name: "foods_nutrients_index", using: :btree

  create_table "usda_foods_nutrients_infile", force: true do |t|
    t.string   "nutrient_databank_number",                null: false
    t.string   "nutrient_number",                         null: false
    t.float    "nutrient_value",               limit: 24, null: false
    t.integer  "num_data_points",                         null: false
    t.float    "standard_error",               limit: 24
    t.string   "src_code",                                null: false
    t.string   "derivation_code"
    t.string   "ref_nutrient_databank_number"
    t.boolean  "add_nutrient_mark"
    t.integer  "num_studies"
    t.float    "min",                          limit: 24
    t.float    "max",                          limit: 24
    t.integer  "degrees_of_freedom"
    t.float    "lower_error_bound",            limit: 24
    t.float    "upper_error_bound",            limit: 24
    t.string   "statistical_comments"
    t.string   "add_mod_date"
    t.string   "confidence_code"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "usda_foods_nutrients_infile", ["nutrient_databank_number", "nutrient_number"], name: "foods_nutrients_index", using: :btree

  create_table "usda_footnotes", force: true do |t|
    t.integer  "nutrient_databank_number", null: false
    t.integer  "footnote_number",          null: false
    t.integer  "nutrient_number"
    t.string   "footnote_type",            null: false
    t.string   "footnote_text",            null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "usda_nutrients", id: false, force: true do |t|
    t.integer  "nutrient_number",       null: false
    t.string   "units",                 null: false
    t.string   "tagname"
    t.string   "nutrient_description",  null: false
    t.integer  "number_decimal_places", null: false
    t.integer  "sort_record_order",     null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "usda_source_codes", force: true do |t|
    t.integer  "code",        null: false
    t.string   "description", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "usda_weights", force: true do |t|
    t.integer  "nutrient_databank_number",            null: false
    t.integer  "sequence_number",                     null: false
    t.float    "amount",                   limit: 24, null: false
    t.string   "measurement_description",             null: false
    t.float    "gram_weight",              limit: 24, null: false
    t.integer  "num_data_points"
    t.float    "standard_deviation",       limit: 24
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: ""
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.integer  "role"
    t.string   "invitation_token"
    t.datetime "invitation_created_at"
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer  "invitation_limit"
    t.integer  "invited_by_id"
    t.string   "invited_by_type"
    t.integer  "invitations_count",      default: 0
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["invitation_token"], name: "index_users_on_invitation_token", unique: true, using: :btree
  add_index "users", ["invitations_count"], name: "index_users_on_invitations_count", using: :btree
  add_index "users", ["invited_by_id"], name: "index_users_on_invited_by_id", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
