class CreateUserMatches < ActiveRecord::Migration[8.0]
  def change
    create_table :user_matches do |t|
      t.references :user1, null: false, foreign_key: { to_table: :users }
      t.references :user2, null: false, foreign_key: { to_table: :users }
      t.references :event, null: false, foreign_key: true

      t.timestamps
    end
    
    add_index :user_matches, [:user1_id, :user2_id, :event_id], unique: true, name: 'index_user_matches_on_user1_user2_event'
  end
end
