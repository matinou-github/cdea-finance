class CreateBalances < ActiveRecord::Migration[7.2]
  def change
    create_table :balances do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :year, null: false
      t.decimal :total_kg_paye, default: 0
      t.decimal :total_garantie, default: 0
      t.decimal :total_remboursement, default: 0
      t.decimal :kg_restants, default: 0
    
      t.timestamps
    end
    
  end
end
