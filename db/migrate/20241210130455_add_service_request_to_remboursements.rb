class AddServiceRequestToRemboursements < ActiveRecord::Migration[7.2]
  def change
    add_reference :remboursements, :service_request, foreign_key: true
  end
end
