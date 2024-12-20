class ChangeRemboursementsTable < ActiveRecord::Migration[7.2]
  def change
    change_table :remboursements do |t|
      t.remove :service_request_id
      t.integer :year, null: false
    end
  end
end
