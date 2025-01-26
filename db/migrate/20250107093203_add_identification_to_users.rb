class AddIdentificationToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :identification, :string
  end
end
