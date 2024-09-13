FactoryBot.define do
  factory :price_fluctuation do
    name {"Tăng giá"}
    start_date {Date.today}
    end_date {Date.today + 1.month}
    rate {2}
  end
end
