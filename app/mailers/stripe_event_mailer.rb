class StripeEventMailer < ActionMailer::Base
  default from: "support@idrivealot.com"

  def failed_payment_notification(user_id)
    @user = User.find(user_id)

    mail to: @user.email, subject: "There was a problem with your most recent payment at idrivealot.com"
  end

end
