class AddCampagneToServicesRequests < ActiveRecord::Migration[7.2]
  def change
    add_column :service_requests, :campagne, :integer
  end
end
