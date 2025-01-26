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

ActiveRecord::Schema[7.2].define(version: 2025_01_25_153259) do
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
    t.string "etat_garantie"
    t.integer "service_request"
    t.index ["user_id"], name: "index_balances_on_user_id"
  end

  create_table "depenses", force: :cascade do |t|
    t.bigint "fonctionnement_id", null: false
    t.string "intitule"
    t.decimal "cout_unitaire"
    t.decimal "montant_total"
    t.decimal "quantite"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["fonctionnement_id"], name: "index_depenses_on_fonctionnement_id"
  end

  create_table "executions", force: :cascade do |t|
    t.bigint "service_request_id", null: false
    t.decimal "superficie"
    t.string "preuve"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "machine_info"
    t.integer "year"
    t.index ["service_request_id"], name: "index_executions_on_service_request_id"
    t.index ["user_id"], name: "index_executions_on_user_id"
  end

  create_table "fonctionnements", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "tractor_id", null: false
    t.integer "campagne"
    t.decimal "cout_unitaire"
    t.decimal "total_depense"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["tractor_id"], name: "index_fonctionnements_on_tractor_id"
    t.index ["user_id"], name: "index_fonctionnements_on_user_id"
  end

  create_table "herbicides", force: :cascade do |t|
    t.string "nom"
    t.decimal "prix"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "garantie_par_litre"
    t.decimal "soja_par_litre"
    t.decimal "prix_achat"
  end

  create_table "indice_settings", force: :cascade do |t|
    t.decimal "kg_ha_laboure", default: "0.0"
    t.decimal "valeur_soja", default: "0.0"
    t.integer "taux_majoration", default: 15
    t.decimal "garantie_ha", default: "0.0"
    t.integer "frais_dossier", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "kg_mais_par_soja", default: "0.0"
    t.string "gerant_name"
    t.decimal "valeur_superficie", default: "0.0"
  end

  create_table "machines", force: :cascade do |t|
    t.string "machine_info"
    t.decimal "superficie"
    t.string "preuve"
    t.bigint "execution_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "tractor_id", null: false
    t.string "year"
    t.index ["execution_id"], name: "index_machines_on_execution_id"
    t.index ["tractor_id"], name: "index_machines_on_tractor_id"
  end

  create_table "remboursements", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "type_remboursement"
    t.float "valeurs"
    t.bigint "credite_par_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "year", null: false
    t.decimal "mais_recuperer"
    t.index ["credite_par_id"], name: "index_remboursements_on_credite_par_id"
    t.index ["user_id"], name: "index_remboursements_on_user_id"
  end

  create_table "restitutions", force: :cascade do |t|
    t.decimal "garantie"
    t.string "restitué_par"
    t.integer "year", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_restitutions_on_user_id"
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
    t.string "recu_par", default: "CDAE-FINANCE"
    t.index ["herbicide_id"], name: "index_service_requests_on_herbicide_id"
    t.index ["user_id"], name: "index_service_requests_on_user_id"
  end

  create_table "soldes", force: :cascade do |t|
    t.integer "campagne"
    t.bigint "user_id", null: false
    t.bigint "tractor_id", null: false
    t.decimal "cout_unitaire"
    t.decimal "superficie_labouree"
    t.decimal "montant_prestation"
    t.decimal "depenses"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "solde_total"
    t.index ["tractor_id"], name: "index_soldes_on_tractor_id"
    t.index ["user_id"], name: "index_soldes_on_user_id"
  end

  create_table "stocks", force: :cascade do |t|
    t.decimal "debit", default: "0.0"
    t.decimal "credit", default: "0.0"
    t.decimal "valeur", default: "0.0"
    t.string "produit"
    t.string "save_by"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_stocks_on_user_id"
  end

  create_table "tractors", force: :cascade do |t|
    t.string "name"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_tractors_on_user_id"
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
    t.string "identification"
    t.string "photo_courte"
    t.string "photo_complete"
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
  add_foreign_key "depenses", "fonctionnements"
  add_foreign_key "executions", "service_requests"
  add_foreign_key "executions", "users"
  add_foreign_key "fonctionnements", "tractors"
  add_foreign_key "fonctionnements", "users"
  add_foreign_key "machines", "executions"
  add_foreign_key "machines", "tractors"
  add_foreign_key "remboursements", "users"
  add_foreign_key "remboursements", "users", column: "credite_par_id"
  add_foreign_key "restitutions", "users"
  add_foreign_key "service_request_herbicides", "herbicides"
  add_foreign_key "service_request_herbicides", "service_requests"
  add_foreign_key "service_requests", "herbicides"
  add_foreign_key "service_requests", "users"
  add_foreign_key "soldes", "tractors"
  add_foreign_key "soldes", "users"
  add_foreign_key "stocks", "users"
  add_foreign_key "tractors", "users"
end
