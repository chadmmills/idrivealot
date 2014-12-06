class StripeEventHandler

  def self.charge_failed_for_customer(customer, event)
    if failed_user = User.find_by(customer_id: customer)
      StripeEventMailer.failed_payment_notification(failed_user.id).deliver
      Rails.logger.info "StripeEvent | Failed payment notification sent to #{failed_user.email}"
    else
      Rails.logger.error "StripeEvent | Error finding Customer #{customer} for charge failed event"
    end
  end

  def self.subscription_cancelled_for_customer(customer)
    if cancelled_user = User.find_by(customer_id: customer)
      cancelled_user.active = false
      cancelled_user.save!
      Rails.logger.info "StripeEvent | Subscription cancelled for #{cancelled_user.email}"
    else
      Rails.logger.error " StripeEvent | Error finding Customer #{customer} for cancelled subscription"
    end
  end

end
