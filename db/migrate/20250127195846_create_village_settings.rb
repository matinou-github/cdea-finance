class CreateVillageSettings < ActiveRecord::Migration[7.2]
  def change
    create_table :village_settings do |t|
      t.string :village
      t.decimal :kg_ha_labouree

      t.timestamps
    end
  end
end
