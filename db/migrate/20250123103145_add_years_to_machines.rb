class AddYearsToMachines < ActiveRecord::Migration[7.2]
  def change
    add_column :machines, :year, :string
  end
end
