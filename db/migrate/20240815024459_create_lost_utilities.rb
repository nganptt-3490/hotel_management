class CreateLostUtilities < ActiveRecord::Migration[7.0]
  def change
    create_table :lost_utilities do |t|
      t.integer :quantity
      t.references :request, null: false, foreign_key: true
      t.references :utility, null: false, foreign_key: true

      t.timestamps
    end
  end
end
