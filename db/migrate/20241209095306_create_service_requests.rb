class CreateServiceRequests < ActiveRecord::Migration[7.2]
  def change
    create_table :service_requests do |t|
      t.references :user, null: false, foreign_key: true
      t.float :superficie
      t.string :herbicide_nom
      t.decimal :herbicide_prix
      t.integer :herbicide_quantite
      t.decimal :garantie
      t.references :herbicide, null: false, foreign_key: true
      t.string :preuve
      t.string :status

      t.timestamps
    end
  end
end
