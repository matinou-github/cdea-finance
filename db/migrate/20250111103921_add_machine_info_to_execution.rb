class AddMachineInfoToExecution < ActiveRecord::Migration[7.2]
  def change
    add_column :executions, :machine_info, :string
    add_column :executions,:year, :integer
  end
end
