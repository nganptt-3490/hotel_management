class CreateRequests < ActiveRecord::Migration[7.0]
  def change
    create_table :requests do |t|
      t.date :start_date
      t.date :end_date
      t.datetime :accepted_at
      t.datetime :rejected_at
      t.text :reject_reason
      t.integer :payment
      t.datetime :paymented_at
      t.datetime :deleted_at
      t.references :user, null: false, foreign_key: true
      t.references :room, null: false, foreign_key: true
      t.references :room_type, null: false, foreign_key: true

      t.timestamps
    end
  end
end
