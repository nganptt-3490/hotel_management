class LostUtility < ApplicationRecord
  belongs_to :request
  belongs_to :utility
end
