class AddServiceRequestToBalances < ActiveRecord::Migration[7.2]
  def change
    add_column :balances, :service_request, :integer
  end
end
