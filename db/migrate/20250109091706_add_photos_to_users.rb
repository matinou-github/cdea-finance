class AddPhotosToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :photo_courte, :string
    add_column :users, :photo_complete, :string
  end
end
