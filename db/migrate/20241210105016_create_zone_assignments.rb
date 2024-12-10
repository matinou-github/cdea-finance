class CreateZoneAssignments < ActiveRecord::Migration[7.2]
  def change
    create_table :zone_assignments do |t|
      t.integer :user_id
      t.integer :assigned_by_id
      t.string :zone

      t.timestamps
    end
  end
end
