FactoryBot.define do
  factory :room do
    room_number { 101 }
    status { :active }
    association :room_type
  end
end
