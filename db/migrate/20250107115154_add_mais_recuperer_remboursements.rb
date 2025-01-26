class AddMaisRecupererRemboursements < ActiveRecord::Migration[7.2]
  def change
    add_column :remboursements, :mais_recuperer, :decimal
  end
end
