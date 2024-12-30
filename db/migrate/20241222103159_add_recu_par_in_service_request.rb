class AddRecuParInServiceRequest < ActiveRecord::Migration[7.2]
  def change
    add_column :service_requests, :recu_par, :string, default: 'CDAE-FINANCE'
  end
end
