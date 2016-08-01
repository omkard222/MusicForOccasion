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

ActiveRecord::Schema.define(version: 20160730140848) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "additional_pictures", force: :cascade do |t|
    t.string   "image"
    t.integer  "profile_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "additional_pictures", ["profile_id"], name: "index_additional_pictures_on_profile_id", using: :btree

  create_table "admins", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.string   "profile_picture"
    t.string   "role"
  end

  add_index "admins", ["email"], name: "index_admins_on_email", unique: true, using: :btree
  add_index "admins", ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true, using: :btree

  create_table "bank_accounts", force: :cascade do |t|
    t.string   "name"
    t.string   "acc_number"
    t.string   "bank_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.integer  "profile_id"
  end

  add_index "bank_accounts", ["bank_name"], name: "index_bank_accounts_on_bank_name", using: :btree
  add_index "bank_accounts", ["deleted_at"], name: "index_bank_accounts_on_deleted_at", using: :btree
  add_index "bank_accounts", ["profile_id"], name: "index_bank_accounts_on_profile_id", using: :btree

  create_table "billing_addresses", force: :cascade do |t|
    t.string   "address1"
    t.string   "address2"
    t.integer  "post_code"
    t.string   "city"
    t.string   "country"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
  end

  add_index "billing_addresses", ["deleted_at"], name: "index_billing_addresses_on_deleted_at", using: :btree
  add_index "billing_addresses", ["user_id"], name: "index_billing_addresses_on_user_id", using: :btree

  create_table "booking_requests", force: :cascade do |t|
    t.datetime "date"
    t.integer  "service_id"
    t.datetime "created_at",                                                null: false
    t.datetime "updated_at",                                                null: false
    t.string   "status"
    t.decimal  "special_price",       precision: 8, scale: 2, default: 0.0
    t.string   "currency"
    t.datetime "deleted_at"
    t.decimal  "confirmed_price"
    t.integer  "service_proposer_id"
    t.float    "offer_price"
    t.string   "event_location"
    t.text     "message"
    t.integer  "updated_by_id"
    t.integer  "profile_id"
  end

  add_index "booking_requests", ["deleted_at"], name: "index_booking_requests_on_deleted_at", using: :btree
  add_index "booking_requests", ["profile_id"], name: "index_booking_requests_on_profile_id", using: :btree
  add_index "booking_requests", ["service_id"], name: "index_booking_requests_on_service_id", using: :btree

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer  "priority",   default: 0, null: false
    t.integer  "attempts",   default: 0, null: false
    t.text     "handler",                null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "genres", force: :cascade do |t|
    t.string "name"
  end

  create_table "instruments", force: :cascade do |t|
    t.string "name"
  end

  create_table "instruments_profiles", id: false, force: :cascade do |t|
    t.integer "profile_id",    null: false
    t.integer "instrument_id", null: false
  end

  add_index "instruments_profiles", ["instrument_id"], name: "index_instruments_profiles_on_instrument_id", using: :btree
  add_index "instruments_profiles", ["profile_id"], name: "index_instruments_profiles_on_profile_id", using: :btree

  create_table "jobs", force: :cascade do |t|
    t.string   "title"
    t.integer  "event_type"
    t.text     "description"
    t.boolean  "transportation"
    t.boolean  "accommodation"
    t.boolean  "food_and_beverage"
    t.integer  "minimum_fb_likes"
    t.integer  "country_of_band"
    t.integer  "booking_fee_type"
    t.integer  "free_fee_type"
    t.decimal  "booking_fee"
    t.string   "currency"
    t.string   "genre_ids"
    t.datetime "deleted_at"
    t.integer  "profile_id"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.string   "country_origin"
  end

  add_index "jobs", ["event_type"], name: "index_jobs_on_event_type", using: :btree
  add_index "jobs", ["profile_id"], name: "index_jobs_on_profile_id", using: :btree

  create_table "mailboxer_conversation_opt_outs", force: :cascade do |t|
    t.integer "unsubscriber_id"
    t.string  "unsubscriber_type"
    t.integer "conversation_id"
  end

  add_index "mailboxer_conversation_opt_outs", ["conversation_id"], name: "index_mailboxer_conversation_opt_outs_on_conversation_id", using: :btree
  add_index "mailboxer_conversation_opt_outs", ["unsubscriber_id", "unsubscriber_type"], name: "index_mailboxer_conversation_opt_outs_on_unsubscriber_id_type", using: :btree

  create_table "mailboxer_conversations", force: :cascade do |t|
    t.string   "subject",    default: ""
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "mailboxer_notifications", force: :cascade do |t|
    t.string   "type"
    t.text     "body"
    t.string   "subject",              default: ""
    t.integer  "sender_id"
    t.string   "sender_type"
    t.integer  "conversation_id"
    t.boolean  "draft",                default: false
    t.string   "notification_code"
    t.integer  "notified_object_id"
    t.string   "notified_object_type"
    t.string   "attachment"
    t.datetime "updated_at",                           null: false
    t.datetime "created_at",                           null: false
    t.boolean  "global",               default: false
    t.datetime "expires"
  end

  add_index "mailboxer_notifications", ["conversation_id"], name: "index_mailboxer_notifications_on_conversation_id", using: :btree
  add_index "mailboxer_notifications", ["notified_object_id", "notified_object_type"], name: "index_mailboxer_notifications_on_notified_object_id_and_type", using: :btree
  add_index "mailboxer_notifications", ["sender_id", "sender_type"], name: "index_mailboxer_notifications_on_sender_id_and_sender_type", using: :btree
  add_index "mailboxer_notifications", ["type"], name: "index_mailboxer_notifications_on_type", using: :btree

  create_table "mailboxer_receipts", force: :cascade do |t|
    t.integer  "receiver_id"
    t.string   "receiver_type"
    t.integer  "notification_id",                            null: false
    t.boolean  "is_read",                    default: false
    t.boolean  "trashed",                    default: false
    t.boolean  "deleted",                    default: false
    t.string   "mailbox_type",    limit: 25
    t.datetime "created_at",                                 null: false
    t.datetime "updated_at",                                 null: false
  end

  add_index "mailboxer_receipts", ["notification_id"], name: "index_mailboxer_receipts_on_notification_id", using: :btree
  add_index "mailboxer_receipts", ["receiver_id", "receiver_type"], name: "index_mailboxer_receipts_on_receiver_id_and_receiver_type", using: :btree

  create_table "musician_genres", force: :cascade do |t|
    t.integer "genre_id"
    t.integer "profile_id"
  end

  add_index "musician_genres", ["genre_id"], name: "index_musician_genres_on_genre_id", using: :btree
  add_index "musician_genres", ["profile_id"], name: "index_musician_genres_on_profile_id", using: :btree

  create_table "profile_histories", force: :cascade do |t|
    t.integer  "profile_id"
    t.string   "old_user_email"
    t.string   "new_user_email"
    t.datetime "migration_date"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  create_table "profiles", force: :cascade do |t|
    t.string   "username"
    t.text     "headline"
    t.text     "biography"
    t.date     "birthday"
    t.datetime "created_at",                                           null: false
    t.datetime "updated_at",                                           null: false
    t.integer  "user_id"
    t.string   "profile_picture"
    t.datetime "deleted_at"
    t.string   "stage_name"
    t.string   "category"
    t.string   "youtube_url"
    t.string   "soundcloud_url"
    t.string   "twitter_token"
    t.string   "twitter_secret"
    t.integer  "twitter_followers"
    t.string   "facebook_token"
    t.string   "facebook_page_id"
    t.integer  "facebook_page_likes"
    t.string   "slug"
    t.boolean  "current"
    t.integer  "profile_type"
    t.datetime "become_current_at"
    t.string   "location"
    t.float    "latitude"
    t.float    "longitude"
    t.string   "tech_rider"
    t.string   "twitter_name"
    t.string   "youtube_channel_id"
    t.integer  "youtube_subscribers"
    t.string   "paypal_account_email"
    t.datetime "paypal_account_email_confirmed_at"
    t.integer  "paypal_account_email_confirmation_status", default: 0
    t.string   "paypal_account_email_confirmation_token"
    t.integer  "position_priority",                        default: 0
    t.string   "previous_account_mail"
    t.datetime "migration_date"
    t.string   "site_logo"
    t.string   "site_url"
    t.string   "invite_friend_name"
    t.string   "invite_friend_email"
    t.datetime "fb_connect_time"
    t.datetime "fb_disconnect_time"
    t.datetime "twitter_connect_time"
    t.datetime "twitter_disconnect_time"
    t.datetime "update_date"
    t.string   "twitter_friend_email"
    t.string   "google_friend_email"
    t.string   "scloud_friend_email"
    t.integer  "sub_type"
    t.integer  "crop_x"
    t.integer  "crop_y"
    t.integer  "crop_h"
    t.integer  "crop_w"
  end

  add_index "profiles", ["deleted_at"], name: "index_profiles_on_deleted_at", using: :btree
  add_index "profiles", ["position_priority"], name: "index_profiles_on_position_priority", using: :btree
  add_index "profiles", ["slug"], name: "index_profiles_on_slug", using: :btree
  add_index "profiles", ["sub_type"], name: "index_profiles_on_sub_type", using: :btree
  add_index "profiles", ["tech_rider"], name: "index_profiles_on_tech_rider", using: :btree
  add_index "profiles", ["user_id"], name: "index_profiles_on_user_id", using: :btree

  create_table "reviews", force: :cascade do |t|
    t.integer  "profile_id"
    t.text     "message"
    t.integer  "score"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.datetime "deleted_at"
    t.integer  "reviewer_id"
  end

  add_index "reviews", ["deleted_at"], name: "index_reviews_on_deleted_at", using: :btree
  add_index "reviews", ["profile_id"], name: "index_reviews_on_profile_id", using: :btree
  add_index "reviews", ["reviewer_id"], name: "index_reviews_on_reviewer_id", using: :btree

  create_table "service_types", force: :cascade do |t|
    t.string "name"
  end

  create_table "services", force: :cascade do |t|
    t.string   "headline"
    t.string   "description"
    t.decimal  "booking_fee",       precision: 11, scale: 2
    t.datetime "created_at",                                                 null: false
    t.datetime "updated_at",                                                 null: false
    t.string   "currency"
    t.datetime "deleted_at"
    t.integer  "service_type_id"
    t.boolean  "is_sunday"
    t.boolean  "is_monday"
    t.boolean  "is_tuesday"
    t.boolean  "is_wednesday"
    t.boolean  "is_thursday"
    t.boolean  "is_friday"
    t.boolean  "is_saturday"
    t.date     "date_from"
    t.date     "date_to"
    t.boolean  "is_default",                                 default: false
    t.integer  "booking_fee_type",                           default: 0
    t.integer  "free_fee_type",                              default: 0
    t.text     "food_and_beverage"
    t.integer  "accommodation",                              default: 0
    t.integer  "fee_time_type",                              default: 0
    t.integer  "profile_id"
    t.integer  "minutes_count"
    t.integer  "min_num_people"
  end

  add_index "services", ["deleted_at"], name: "index_services_on_deleted_at", using: :btree

  create_table "soundcloud_data", force: :cascade do |t|
    t.integer  "profile_id"
    t.string   "access_token",     null: false
    t.string   "refresh_token",    null: false
    t.string   "client_id",        null: false
    t.datetime "token_expires_at"
    t.datetime "deleted_at"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  add_index "soundcloud_data", ["profile_id"], name: "index_soundcloud_data_on_profile_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                           default: "",    null: false
    t.string   "encrypted_password",              default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                   default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "provider"
    t.string   "uid"
    t.string   "phone_number"
    t.string   "stripe_token"
    t.string   "payment_method"
    t.datetime "deleted_at"
    t.boolean  "banned"
    t.string   "first_name"
    t.string   "last_name"
    t.boolean  "notify_create_offer",             default: true
    t.boolean  "notify_create_booking",           default: true
    t.boolean  "notify_accept_booking",           default: true
    t.boolean  "notify_reject_booking",           default: true
    t.boolean  "notify_create_special_offer",     default: true
    t.boolean  "notify_cancel_booking",           default: true
    t.string   "avatar"
    t.boolean  "notify_cancel_confirmed_booking", default: true
    t.boolean  "notify_receive_message",          default: true
    t.boolean  "premium_account",                 default: false
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["deleted_at"], name: "index_users_on_deleted_at", using: :btree
  add_index "users", ["email"], name: "index_users_on_email", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  add_foreign_key "additional_pictures", "profiles"
  add_foreign_key "billing_addresses", "users"
  add_foreign_key "booking_requests", "services"
  add_foreign_key "jobs", "profiles"
  add_foreign_key "mailboxer_conversation_opt_outs", "mailboxer_conversations", column: "conversation_id", name: "mb_opt_outs_on_conversations_id"
  add_foreign_key "mailboxer_notifications", "mailboxer_conversations", column: "conversation_id", name: "notifications_on_conversation_id"
  add_foreign_key "mailboxer_receipts", "mailboxer_notifications", column: "notification_id", name: "receipts_on_notification_id"
  add_foreign_key "profiles", "users"
end
