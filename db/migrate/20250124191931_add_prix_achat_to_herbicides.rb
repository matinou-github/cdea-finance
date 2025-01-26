class AddPrixAchatToHerbicides < ActiveRecord::Migration[7.2]
  def change
    add_column :herbicides, :prix_achat, :decimal
  end
end
