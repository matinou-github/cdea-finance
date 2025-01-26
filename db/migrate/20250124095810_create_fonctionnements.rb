class CreateFonctionnements < ActiveRecord::Migration[7.2]
  def change
    create_table :fonctionnements do |t|
      t.references :user, null: false, foreign_key: true
      t.references :tractor, null: false, foreign_key: true
      t.integer :campagne
      t.decimal :cout_unitaire
      t.decimal :total_depense

      t.timestamps
    end
  end
end
