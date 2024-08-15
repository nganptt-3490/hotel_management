class CreatePriceFluctuations < ActiveRecord::Migration[7.0]
  def change
    create_table :price_fluctuations do |t|
      t.string :name
      t.date :start_date
      t.date :end_date
      t.integer :rate

      t.timestamps
    end
  end
end
