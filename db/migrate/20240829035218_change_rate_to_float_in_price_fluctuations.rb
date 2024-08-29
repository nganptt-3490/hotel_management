class ChangeRateToFloatInPriceFluctuations < ActiveRecord::Migration[7.0]
  def up
    change_column :price_fluctuations, :rate, :float
  end

  def down
    change_column :price_fluctuations, :rate, :integer
  end
end
