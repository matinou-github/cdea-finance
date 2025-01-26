class ChangeIndiceSettingsTable < ActiveRecord::Migration[7.2]
  def change
    change_table :indice_settings do |t|
      t.remove :kg_litre_octroi
      t.remove :garantie_litre
      t.decimal :kg_mais_par_soja, default: 0
    end
  end
end
