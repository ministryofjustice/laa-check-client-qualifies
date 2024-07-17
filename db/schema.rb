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

ActiveRecord::Schema[7.1].define(version: 2024_06_15_073559) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "action_text_rich_texts", force: :cascade do |t|
    t.string "name", null: false
    t.text "body"
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["record_type", "record_id", "name"], name: "index_action_text_rich_texts_uniqueness", unique: true
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "admins", force: :cascade do |t|
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

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

  create_table "banners", force: :cascade do |t|
    t.string "title", null: false
    t.datetime "display_from_utc", precision: nil, null: false
    t.datetime "display_until_utc", precision: nil, null: false
    t.boolean "published", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "change_logs", force: :cascade do |t|
    t.string "title", null: false
    t.string "tag"
    t.date "released_on", null: false
    t.boolean "published", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "completed_user_journeys", force: :cascade do |t|
    t.string "assessment_id", null: false
    t.boolean "certificated", null: false
    t.boolean "partner", null: false
    t.boolean "person_over_60", null: false
    t.boolean "passported", null: false
    t.boolean "main_dwelling_owned", null: false
    t.boolean "vehicle_owned", null: false
    t.boolean "smod_assets", null: false
    t.string "outcome", null: false
    t.boolean "capital_contribution", null: false
    t.boolean "income_contribution", null: false
    t.date "completed"
    t.boolean "form_downloaded", default: false
    t.string "matter_type"
    t.boolean "asylum_support"
    t.string "client_age"
    t.jsonb "session"
    t.index ["assessment_id"], name: "index_completed_user_journeys_on_assessment_id", unique: true
  end

  create_table "feature_flag_overrides", force: :cascade do |t|
    t.string "key"
    t.boolean "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "freetext_feedbacks", force: :cascade do |t|
    t.text "text", null: false
    t.string "page", null: false
    t.string "level_of_help"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "issue_updates", force: :cascade do |t|
    t.bigint "issue_id"
    t.text "content", null: false
    t.datetime "utc_timestamp", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["issue_id"], name: "index_issue_updates_on_issue_id"
  end

  create_table "issues", force: :cascade do |t|
    t.string "title", null: false
    t.text "banner_content", null: false
    t.string "status", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "providers", force: :cascade do |t|
    t.string "email", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "satisfaction_feedbacks", force: :cascade do |t|
    t.string "satisfied", null: false
    t.string "level_of_help", null: false
    t.string "outcome", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "comment"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
end
