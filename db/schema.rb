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

ActiveRecord::Schema[7.2].define(version: 2024_12_09_145500) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "herbicides", force: :cascade do |t|
    t.string "nom"
    t.decimal "prix"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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

  add_foreign_key "service_requests", "herbicides"
  add_foreign_key "service_requests", "users"
end
