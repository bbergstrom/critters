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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110912025528) do

  create_table "critters", :force => true do |t|
    t.string   "name"
    t.string   "url"
    t.integer  "level"
    t.integer  "hp"
    t.integer  "dodge"
    t.integer  "crit"
    t.integer  "physical_damage"
    t.integer  "fire_damage"
    t.integer  "earth_damage"
    t.integer  "water_damage"
    t.integer  "air_damage"
    t.integer  "light_damage"
    t.integer  "dark_damage"
    t.integer  "absorb_fire"
    t.integer  "absorb_earth"
    t.integer  "absorb_water"
    t.integer  "absorb_air"
    t.integer  "absorb_light"
    t.integer  "absorb_dark"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.string   "sex"
    t.boolean  "has_fire_damage"
    t.boolean  "has_earth_damage"
    t.boolean  "has_water_damage"
    t.boolean  "has_air_damage"
    t.boolean  "has_light_damage"
    t.boolean  "has_dark_damage"
    t.boolean  "has_absorb_fire"
    t.boolean  "has_absorb_earth"
    t.boolean  "has_absorb_water"
    t.boolean  "has_absorb_air"
    t.boolean  "has_absorb_light"
    t.boolean  "has_absorb_dark"
    t.boolean  "has_crit"
    t.boolean  "has_dodge"
  end

  create_table "users", :force => true do |t|
    t.string   "username"
    t.string   "email"
    t.string   "password_hash"
    t.string   "password_salt"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
