class CreateDepenses < ActiveRecord::Migration[7.2]
  def change
    create_table :depenses do |t|
      t.references :fonctionnement, null: false, foreign_key: true
      t.string :intitule
      t.decimal :cout_unitaire
      t.decimal :montant_total
      t.decimal :quantite

      t.timestamps
    end
  end
end
