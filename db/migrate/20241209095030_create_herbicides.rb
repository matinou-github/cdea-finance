class CreateHerbicides < ActiveRecord::Migration[7.2]
  def change
    create_table :herbicides do |t|
      t.string :nom
      t.decimal :prix

      t.timestamps
    end
  end
end
