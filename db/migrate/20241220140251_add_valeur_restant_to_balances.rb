class AddValeurRestantToBalances < ActiveRecord::Migration[7.2]
  def change
    add_column :balances, :valeur_restants, :decimal, default: 0
  end
end
