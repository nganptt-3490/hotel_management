class CreateRoomTypes < ActiveRecord::Migration[7.0]
  def change
    create_table :room_types do |t|
      t.string :name
      t.integer :price_weekday
      t.integer :price_weekend
      t.integer :area
      t.integer :number_of_guest_max

      t.timestamps
    end
  end
end
