class AddGarantieParLitreToHerbicides < ActiveRecord::Migration[7.2]
  def change
    add_column :herbicides, :garantie_par_litre, :decimal
  end
end
