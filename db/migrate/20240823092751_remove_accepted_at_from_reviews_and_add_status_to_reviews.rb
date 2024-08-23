class RemoveAcceptedAtFromReviewsAndAddStatusToReviews < ActiveRecord::Migration[7.0]
  def change
    remove_column :reviews, :accepted_at, :datetime
    add_column :reviews, :status, :integer, default: 0, null: false
  end
end
