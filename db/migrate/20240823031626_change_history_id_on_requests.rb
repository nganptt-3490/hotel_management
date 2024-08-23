class ChangeHistoryIdOnRequests < ActiveRecord::Migration[7.0]
  def change
    change_column_null :requests, :history_id, true
  end
end
