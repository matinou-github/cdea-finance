class AddReductionToSoldes < ActiveRecord::Migration[7.2]
  def change
    add_column :soldes, :reduction, :decimal, default: 0
  end
end
