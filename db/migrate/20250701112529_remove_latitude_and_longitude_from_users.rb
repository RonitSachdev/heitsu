class RemoveLatitudeAndLongitudeFromUsers < ActiveRecord::Migration[8.0]
  def change
    remove_column :users, :latitude, :decimal
    remove_column :users, :longitude, :decimal
  end
end
