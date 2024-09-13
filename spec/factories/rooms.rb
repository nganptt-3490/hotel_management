FactoryBot.define do
  factory :room do
    room_number { 101 }
    status { :active }
    description { "A standard room." }
    association :room_type
  end
end
