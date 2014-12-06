require 'rails_helper'

RSpec.describe StripeEventHandler do

  let(:stripe_helper) { StripeMock.create_test_helper }
  before { StripeMock.start }
  after { StripeMock.stop }

  it " sends an email on failed charge" do
    set_up_stripe_event

    StripeEventHandler.charge_failed_for_customer(@event.data.object.customer, @event)

    expect(ActionMailer::Base.deliveries.last.to.first).to eq @stripe_user.email
  end

  it " locks the user on cancelled subscription" do
    set_up_stripe_event
    event = StripeMock.mock_webhook_event("customer.subscription.deleted", {
      customer: @stripe_user.customer_id
    })
    StripeEventHandler.subscription_cancelled_for_customer(event.data.object.customer)
    @stripe_user.reload
    expect(@stripe_user.active?).to be_falsey
  end

  def set_up_stripe_event
    plan = stripe_helper.create_plan(:id => 'idrivealot_monthly', :amount => 200)
    @stripe_user = build(:user)
    @stripe_user.stripe_card_token = stripe_helper.generate_card_token
    @stripe_user.save_with_payment

    @event = StripeMock.mock_webhook_event("charge.failed", {
      customer: @stripe_user.customer_id
    })
  end
end
