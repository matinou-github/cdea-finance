class AddValeurMajoreeToBalances < ActiveRecord::Migration[7.2]
  def change
    add_column :balances, :valeur_majoree_kg, :decimal
    add_column :balances, :valeur_majoree_numeraire, :decimal
  end
end
