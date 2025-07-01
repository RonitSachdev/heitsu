class CreateGroupJoinRequests < ActiveRecord::Migration[8.0]
  def change
    create_table :group_join_requests do |t|
      t.references :user, null: false, foreign_key: true
      t.references :group, null: false, foreign_key: true
      t.string :status, default: 'pending'
      t.text :message

      t.timestamps
    end
    
    add_index :group_join_requests, [:user_id, :group_id], unique: true
  end
end
