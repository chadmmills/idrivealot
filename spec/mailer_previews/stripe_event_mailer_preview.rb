class StripeEventMailerPreview < ActionMailer::Preview

  def failed_payment_notification
    StripeEventMailer.failed_payment_notification(User.first.id)
  end
end
