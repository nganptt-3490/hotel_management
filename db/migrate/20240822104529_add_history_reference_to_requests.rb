class AddHistoryReferenceToRequests < ActiveRecord::Migration[7.0]
  def change
    add_reference :requests, :history, null: false, foreign_key: true
  end
end
