desc "revenue statistic"
task revenue_statistic: :environment do
  AdminMailer.revenue_statistic.deliver!
end
