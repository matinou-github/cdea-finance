class CreateMachines < ActiveRecord::Migration[7.2]
  def change
    create_table :machines do |t|
      t.string :machine_info
      t.decimal :superficie
      t.string :preuve
      t.references :execution, null: false, foreign_key: true

      t.timestamps
    end
  end
end
