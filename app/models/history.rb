class History < ApplicationRecord
  belongs_to :request
  enum status: {pending: 0, canceled: 1, accepted: 2, rejected: 3}
  scope :latest_id, lambda {|request_id|
    where(request_id:)
      .maximum(:id)
  }
  scope :with_status, lambda {|status|
    where(status: statuses[status])
  }
  scope :latest, ->{order(created_at: :desc).first}
end
