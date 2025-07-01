class CreateGroups < ActiveRecord::Migration[8.0]
  def change
    create_table :groups do |t|
      t.string :name
      t.text :description
      t.references :event, null: false, foreign_key: true
      t.references :creator, null: false, foreign_key: { to_table: :users }
      t.integer :max_members

      t.timestamps
    end
  end
end
