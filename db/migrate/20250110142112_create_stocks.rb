class CreateStocks < ActiveRecord::Migration[7.2]
  def change
    create_table :stocks do |t|
      t.decimal :debit, default: 0
      t.decimal :credit, default: 0
      t.decimal :valeur, default: 0
      t.string :produit
      t.string :save_by
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
