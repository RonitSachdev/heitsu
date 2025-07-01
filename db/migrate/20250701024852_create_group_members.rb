class CreateGroupMembers < ActiveRecord::Migration[8.0]
  def change
    create_table :group_members do |t|
      t.references :user, null: false, foreign_key: true
      t.references :group, null: false, foreign_key: true
      t.string :role, default: 'member'

      t.timestamps
    end
    
    add_index :group_members, [:user_id, :group_id], unique: true
  end
end
