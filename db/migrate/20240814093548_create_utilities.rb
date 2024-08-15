class CreateUtilities < ActiveRecord::Migration[7.0]
  def change
    create_table :utilities do |t|
      t.integer :type
      t.string :name
      t.integer :quantity
      t.integer :cost

      t.timestamps
    end
  end
end
