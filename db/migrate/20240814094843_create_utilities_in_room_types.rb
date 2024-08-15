class CreateUtilitiesInRoomTypes < ActiveRecord::Migration[7.0]
  def change
    create_table :utilities_in_room_types do |t|
      t.integer :quantity
      t.text :description
      t.references :utility, null: false, foreign_key: true
      t.references :room_type, null: false, foreign_key: true

      t.timestamps
    end
  end
end
