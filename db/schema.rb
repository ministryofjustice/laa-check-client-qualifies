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

ActiveRecord::Schema[7.0].define(version: 2023_02_21_125618) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "analytics_events", force: :cascade do |t|
    t.string "event_type", null: false
    t.string "page", null: false
    t.string "assessment_code"
    t.string "browser_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["assessment_code"], name: "index_analytics_events_on_assessment_code"
    t.index ["created_at"], name: "index_analytics_events_on_created_at"
  end

end
