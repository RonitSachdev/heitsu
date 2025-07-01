class CreateGroupSwipes < ActiveRecord::Migration[8.0]
  def change
    create_table :group_swipes do |t|
      t.references :swiper, null: false, foreign_key: { to_table: :users }
      t.references :group, null: false, foreign_key: true
      t.string :direction

      t.timestamps
    end
    
    add_index :group_swipes, [:swiper_id, :group_id], unique: true
  end
end
