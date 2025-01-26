class CreateRestitutions < ActiveRecord::Migration[7.2]
  def change
    create_table :restitutions do |t|
      t.decimal :garantie
      t.string :restitué_par
      t.integer :year, null: false
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
