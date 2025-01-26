class AddSoldeTotalToSoldes < ActiveRecord::Migration[7.2]
  def change
    add_column :soldes, :solde_total, :decimal
  end
end
