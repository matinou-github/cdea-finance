class AddSojaParLitreToHerbicides < ActiveRecord::Migration[7.2]
  def change
    add_column :herbicides, :soja_par_litre, :decimal
  end
end
