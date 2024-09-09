class AdminMailer < ApplicationMailer
  def revenue_statistic
    @this_month = Time.zone.now.strftime("%B %Y")
    mail to: "admin@example.com",
         subject: t("mail.monthly_noti", month: @this_month)
  end
end
