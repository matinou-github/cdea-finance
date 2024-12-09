class AddStatusRequestToServiceRequest < ActiveRecord::Migration[7.2]
  def change
    add_column :service_requests, :status_request, :string
  end
end
