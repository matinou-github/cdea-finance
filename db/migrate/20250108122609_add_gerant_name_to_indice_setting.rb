class AddGerantNameToIndiceSetting < ActiveRecord::Migration[7.2]
  def change
    add_column :indice_settings, :gerant_name, :string
  end
end
