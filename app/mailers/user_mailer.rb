class UserMailer < ApplicationMailer
  def request_accept user, request
    @user = user
    @request = request
    mail to: user.email, subject: t("request_accepted")
  end

  def request_reject user, request
    @user = user
    @request = request
    mail to: user.email, subject: t("request_rejected")
  end
end
