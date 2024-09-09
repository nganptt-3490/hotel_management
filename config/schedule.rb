every '0 7 28-31 * *' do
  rake "revenue_statistic", if: "Date.today.end_of_month == Date.today"
end
