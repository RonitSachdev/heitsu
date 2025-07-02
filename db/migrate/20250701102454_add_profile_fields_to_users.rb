class AddProfileFieldsToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :date_of_birth, :date
    add_column :users, :city, :string
    add_column :users, :interests, :text
    add_column :users, :occupation, :string
    add_column :users, :education, :string
    add_column :users, :height, :string
    add_column :users, :photos, :text
    add_column :users, :latitude, :decimal
    add_column :users, :longitude, :decimal
  end
end
