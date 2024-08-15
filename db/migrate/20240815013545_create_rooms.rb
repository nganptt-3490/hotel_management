class CreateRooms < ActiveRecord::Migration[7.0]
  def change
    create_table :rooms do |t|
      t.integer :room_number
      t.integer :status
      t.text :description
      t.datetime :deleted_at
      t.references :room_type, null: false, foreign_key: true

      t.timestamps
    end
  end
end
