class CreateServiceRequestHerbicides < ActiveRecord::Migration[7.2]
  def change
    create_table :service_request_herbicides do |t|
      t.references :service_request, null: false, foreign_key: true
      t.references :herbicide, null: false, foreign_key: true
      t.integer :quantite, null: false, default: 0

      t.timestamps
    end
  end
end
