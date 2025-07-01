class CreateEvents < ActiveRecord::Migration[8.0]
  def change
    create_table :events do |t|
      t.string :title
      t.text :description
      t.string :location
      t.datetime :event_date
      t.string :category
      t.string :image
      t.integer :max_attendees

      t.timestamps
    end
  end
end
