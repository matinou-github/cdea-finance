class CreateRemboursementDetails < ActiveRecord::Migration[7.2]
  def change
    create_table :remboursement_details do |t|
      t.references :remboursement, null: false, foreign_key: true
      t.string :sac
      t.decimal :valeur_kg

      t.timestamps
    end
  end
end
