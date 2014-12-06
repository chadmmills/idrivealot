class StripeEventHandler

  def self.charge_failed_for_customer(customer, event)
    if failed_user = User.find_by(customer_id: customer)
      failed_user.update(active: false)
      StripeEventMailer.failed_payment_notification(failed_user.id).deliver
      Rails.logger.info "StripeEvent | Failed payment notification sent to #{failed_user.email}"
    else
      Rails.logger.error "StripeEvent | Error finding Customer #{customer} for charge failed event"
    end
  end

  def self.subscription_cancelled_for_customer(customer)
    if cancelled_user = User.find_by(customer_id: customer)
      cancelled_user.destroy
      Rails.logger.info "StripeEvent | Subscription cancelled for #{cancelled_user.email}"
    else
      Rails.logger.error " StripeEvent | Error finding Customer #{customer} for cancelled subscription"
    end
  end

end
