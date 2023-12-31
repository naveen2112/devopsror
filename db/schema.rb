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

ActiveRecord::Schema.define(version: 2022_06_23_041020) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_admin_comments", force: :cascade do |t|
    t.string "namespace"
    t.text "body"
    t.string "resource_type"
    t.bigint "resource_id"
    t.string "author_type"
    t.bigint "author_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author"
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace"
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource"
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
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "admin_users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_admin_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true
  end

  create_table "cards", force: :cascade do |t|
    t.bigint "user_id"
    t.string "last_four_digits"
    t.string "expiry"
    t.string "stripe_card_id"
    t.string "token"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "default_card", default: true
    t.index ["user_id"], name: "index_cards_on_user_id"
  end

  create_table "commentries", force: :cascade do |t|
    t.bigint "post_id"
    t.text "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["post_id"], name: "index_commentries_on_post_id"
  end

  create_table "companies", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "url"
    t.integer "user_limit", default: 20
    t.integer "plan_type", default: 0
    t.integer "subscription_status", default: 0
    t.date "trail_start_date"
    t.date "trail_end_date"
    t.date "next_billing_date"
    t.date "subscription_cancelled_at"
    t.float "charged_amount", default: 0.0
    t.integer "billing_type", default: 0
  end

  create_table "imports", force: :cascade do |t|
    t.bigint "company_id"
    t.integer "status", default: 0
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "user_id"
    t.boolean "invite", default: false
    t.index ["company_id"], name: "index_imports_on_company_id"
  end

  create_table "integrated_accounts", force: :cascade do |t|
    t.bigint "user_id"
    t.integer "platform"
    t.jsonb "data"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "company_id"
    t.index ["company_id"], name: "index_integrated_accounts_on_company_id"
    t.index ["user_id"], name: "index_integrated_accounts_on_user_id"
  end

  create_table "linkedin_social_actions", force: :cascade do |t|
    t.bigint "post_id", null: false
    t.bigint "company_id", null: false
    t.integer "action_type"
    t.integer "platform"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["company_id"], name: "index_linkedin_social_actions_on_company_id"
    t.index ["post_id"], name: "index_linkedin_social_actions_on_post_id"
  end

  create_table "post_user_shares", force: :cascade do |t|
    t.bigint "post_id", null: false
    t.bigint "user_id", null: false
    t.bigint "company_id", null: false
    t.string "share_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "likes_count", default: 0
    t.integer "comments_count", default: 0
    t.integer "reach_count", default: 0
    t.index ["company_id"], name: "index_post_user_shares_on_company_id"
    t.index ["post_id"], name: "index_post_user_shares_on_post_id"
    t.index ["user_id"], name: "index_post_user_shares_on_user_id"
  end

  create_table "posts", force: :cascade do |t|
    t.bigint "company_id"
    t.string "title"
    t.text "platform_name", default: [], array: true
    t.string "main_url"
    t.boolean "notification", default: false
    t.integer "status", default: 0
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "created_by"
    t.integer "shared_count", default: 0
    t.string "preview_image_url"
    t.string "preview_url_title"
    t.index ["company_id"], name: "index_posts_on_company_id"
  end

  create_table "posts_tags", id: false, force: :cascade do |t|
    t.bigint "post_id"
    t.bigint "tag_id"
    t.index ["post_id"], name: "index_posts_tags_on_post_id"
    t.index ["tag_id"], name: "index_posts_tags_on_tag_id"
  end

  create_table "tags", force: :cascade do |t|
    t.bigint "company_id"
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["company_id"], name: "index_tags_on_company_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "first_name"
    t.string "last_name"
    t.boolean "terms_and_condition", default: false
    t.integer "role", default: 0
    t.bigint "company_id"
    t.string "stripe_customer_id"
    t.boolean "terms_and_conditions", default: false
    t.boolean "subscribe", default: true
    t.string "linked_in_id"
    t.boolean "invite", default: false
    t.boolean "active", default: false
    t.integer "login_count", default: 0
    t.boolean "invited", default: false
    t.integer "cards_count", default: 0
    t.boolean "accepted", default: false
    t.index ["company_id"], name: "index_users_on_company_id"
    t.index ["email", "company_id"], name: "index_users_on_email_and_company_id", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "linkedin_social_actions", "companies"
  add_foreign_key "linkedin_social_actions", "posts"
  add_foreign_key "post_user_shares", "companies"
  add_foreign_key "post_user_shares", "posts"
  add_foreign_key "post_user_shares", "users"
end
