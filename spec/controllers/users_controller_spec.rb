require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let(:stripe_helper) { StripeMock.create_test_helper }
  before { StripeMock.start }
  after { StripeMock.stop }

  it "updates the users payment method" do
    @request.env["devise.mapping"] = Devise.mappings[:user]
    plan = stripe_helper.create_plan(:id => 'idrivealot_monthly', :amount => 200)
    stripe_user = build(:user)
    stripe_user.stripe_card_token = stripe_helper.generate_card_token
    stripe_user.save_with_payment
    post :update_payment, id: stripe_user.id, user: {stripe_card_token: stripe_helper.generate_card_token}
    expect(response).to redirect_to mileage_records_path
  end
end
