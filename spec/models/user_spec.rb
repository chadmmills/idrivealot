require 'spec_helper'

describe User do
  it "is invalid with no attributes" do
    expect(User.new).to be_invalid
  end

  it "is valid with valid attributes" do
    expect(build(:user)).to be_valid
  end

  it "is invalid without a customer id" do
    expect(build(:user, customer_id: nil)).to be_invalid
  end

  describe "StripeCustomer" do
    let(:stripe_helper) { StripeMock.create_test_helper }
    before { StripeMock.start }
    after { StripeMock.stop }

    it "#save_with_payment saves a Stripe Customer" do
      plan = stripe_helper.create_plan(:id => 'idrivealot_monthly', :amount => 200)
      stripe_user = build(:user)
      stripe_user.stripe_card_token = stripe_helper.generate_card_token
      expect(stripe_user.save_with_payment).to_not eq false
    end
  end
end
