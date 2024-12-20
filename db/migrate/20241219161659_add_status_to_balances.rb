class AddStatusToBalances < ActiveRecord::Migration[7.2]
  def change
     add_column :balances, :status, :string, default: 'en cours'
  end
end
