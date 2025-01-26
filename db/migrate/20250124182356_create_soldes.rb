class CreateSoldes < ActiveRecord::Migration[7.2]
  def change
    create_table :soldes do |t|
      t.integer :campagne
      t.references :user, null: false, foreign_key: true
      t.references :tractor, null: false, foreign_key: true
      t.decimal :cout_unitaire
      t.decimal :superficie_labouree
      t.decimal :montant_prestation
      t.decimal :depenses
      t.timestamps
    end
  end
end
