class ChangeHerbicideIdToAllowNullInServiceRequests < ActiveRecord::Migration[7.2]
  def change
    change_column_null :service_requests, :herbicide_id, true
  end
end
