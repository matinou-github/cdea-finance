class CreateRemboursements < ActiveRecord::Migration[7.2]
  def change
    create_table :remboursements do |t|
      t.references :user, null: false, foreign_key: true
      t.string :type_remboursement
      t.float :valeurs
      t.references :credite_par, null: false, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end
