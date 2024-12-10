class CreateExecutions < ActiveRecord::Migration[7.2]
  def change
    create_table :executions do |t|
      t.references :service_request, null: false, foreign_key: true
      t.decimal :superficie
      t.string :preuve
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
