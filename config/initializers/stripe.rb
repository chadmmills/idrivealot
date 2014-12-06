Stripe.api_key = Rails.application.secrets.stripe_secret_key

StripeEvent.configure do |events|
  events.subscribe 'charge.failed' do |event|
    StripeEventHandler.charge_failed_for_customer(event.data.object.customer, event)
  end

  events.subscribe 'customer.subscription.deleted' do |event|
    StripeEventHandler.subscription_cancelled_for_customer(event.data.object.customer, event)
  end
end
