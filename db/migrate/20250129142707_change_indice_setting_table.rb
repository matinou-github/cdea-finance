class ChangeIndiceSettingTable < ActiveRecord::Migration[7.2]
  def change
    change_table :indice_settings do |t|
      t.remove :kg_ha_laboure
    end
  end
end
