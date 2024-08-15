class CreateRoomCosts < ActiveRecord::Migration[7.0]
  def change
    create_table :room_costs do |t|
      t.date :use_date
      t.references :request, null: false, foreign_key: true
      t.references :price_fluctuation, null: false, foreign_key: true

      t.timestamps
    end
  end
end
