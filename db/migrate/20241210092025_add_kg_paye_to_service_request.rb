class AddKgPayeToServiceRequest < ActiveRecord::Migration[7.2]
  def change
    add_column :service_requests, :kg_paye, :string
  end
end
