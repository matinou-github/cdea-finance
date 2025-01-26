class AddEtatGarantieToBalances < ActiveRecord::Migration[7.2]
  def change
    add_column :balances, :etat_garantie, :string
  end
end
