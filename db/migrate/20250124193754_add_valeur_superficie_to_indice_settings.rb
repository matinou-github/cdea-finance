class AddValeurSuperficieToIndiceSettings < ActiveRecord::Migration[7.2]
  def change
    add_column :indice_settings, :valeur_superficie, :decimal, default: 0
  end
end
