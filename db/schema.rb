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

ActiveRecord::Schema[7.2].define(version: 2024_12_20_140251) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

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

  create_table "balances", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.integer "year", null: false
    t.decimal "total_kg_paye", default: "0.0"
    t.decimal "total_garantie", default: "0.0"
    t.decimal "total_remboursement", default: "0.0"
    t.decimal "kg_restants", default: "0.0"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "valeur_majoree_kg"
    t.decimal "valeur_majoree_numeraire"
    t.string "status", default: "en cours"
    t.decimal "valeur_restants", default: "0.0"
    t.index ["user_id"], name: "index_balances_on_user_id"
  end

  create_table "executions", force: :cascade do |t|
    t.bigint "service_request_id", null: false
    t.decimal "superficie"
    t.string "preuve"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["service_request_id"], name: "index_executions_on_service_request_id"
    t.index ["user_id"], name: "index_executions_on_user_id"
  end

  create_table "herbicides", force: :cascade do |t|
    t.string "nom"
    t.decimal "prix"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "garantie_par_litre"
    t.decimal "soja_par_litre"
  end

  create_table "indice_settings", force: :cascade do |t|
    t.decimal "kg_ha_laboure", default: "0.0"
    t.decimal "kg_litre_octroi", default: "0.0"
    t.decimal "valeur_soja", default: "0.0"
    t.integer "taux_majoration", default: 15
    t.decimal "garantie_ha", default: "0.0"
    t.decimal "garantie_litre", default: "0.0"
    t.integer "frais_dossier", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "remboursements", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "type_remboursement"
    t.float "valeurs"
    t.bigint "credite_par_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "year", null: false
    t.index ["credite_par_id"], name: "index_remboursements_on_credite_par_id"
    t.index ["user_id"], name: "index_remboursements_on_user_id"
  end

  create_table "service_request_herbicides", force: :cascade do |t|
    t.bigint "service_request_id", null: false
    t.bigint "herbicide_id", null: false
    t.integer "quantite", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["herbicide_id"], name: "index_service_request_herbicides_on_herbicide_id"
    t.index ["service_request_id"], name: "index_service_request_herbicides_on_service_request_id"
  end

  create_table "service_requests", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.float "superficie"
    t.string "herbicide_nom"
    t.decimal "herbicide_prix"
    t.integer "herbicide_quantite"
    t.decimal "garantie"
    t.bigint "herbicide_id"
    t.string "preuve"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "status_request"
    t.string "kg_paye"
    t.index ["herbicide_id"], name: "index_service_requests_on_herbicide_id"
    t.index ["user_id"], name: "index_service_requests_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: ""
    t.string "encrypted_password", default: "", null: false
    t.string "nom", null: false
    t.string "prenom", null: false
    t.string "phone_number", null: false
    t.string "commune"
    t.string "village"
    t.string "identity_card_photo"
    t.string "role", default: "agriculteur", null: false
    t.string "zone"
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["phone_number"], name: "index_users_on_phone_number", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "zone_assignments", force: :cascade do |t|
    t.integer "user_id"
    t.integer "assigned_by_id"
    t.string "zone"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "balances", "users"
  add_foreign_key "executions", "service_requests"
  add_foreign_key "executions", "users"
  add_foreign_key "remboursements", "users"
  add_foreign_key "remboursements", "users", column: "credite_par_id"
  add_foreign_key "service_request_herbicides", "herbicides"
  add_foreign_key "service_request_herbicides", "service_requests"
  add_foreign_key "service_requests", "herbicides"
  add_foreign_key "service_requests", "users"
end
