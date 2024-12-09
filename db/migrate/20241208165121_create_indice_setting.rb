class CreateIndiceSetting < ActiveRecord::Migration[7.2]
  def change
    create_table :indice_settings do |t|
      t.decimal :kg_ha_laboure, default: 0
      t.decimal :kg_litre_octroi, default: 0
      t.decimal :valeur_soja, default: 0
      t.integer :taux_majoration, default: 15
      t.decimal :garantie_ha, default: 0
      t.decimal :garantie_litre, default: 0
      t.integer :frais_dossier, default: 0

      t.timestamps
    end
  end
end
