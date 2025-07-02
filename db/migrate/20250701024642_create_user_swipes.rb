class CreateUserSwipes < ActiveRecord::Migration[8.0]
  def change
    create_table :user_swipes do |t|
      t.references :swiper, null: false, foreign_key: { to_table: :users }
      t.references :swiped_user, null: false, foreign_key: { to_table: :users }
      t.references :event, null: false, foreign_key: true
      t.string :direction

      t.timestamps
    end

    add_index :user_swipes, [ :swiper_id, :swiped_user_id, :event_id ], unique: true, name: 'index_user_swipes_on_swiper_swiped_user_event'
  end
end
