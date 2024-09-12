FactoryBot.define do
  factory :room_type do
    name { "Single Room" }
    price_weekday { 100 }  
    price_weekend { 200 }  
  end
end
