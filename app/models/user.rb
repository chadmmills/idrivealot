class User < ActiveRecord::Base

  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :trackable, :validatable

  has_many :mileage_records

  attr_accessor :stripe_card_token

  validates :customer_id, presence: true

  def mileage_records_for_download(search_date:)
    mileage_records.
      order(:record_date).
      where("record_date <= ? AND record_date > ?", search_date.end_of_month, search_date-1)
  end

  def save_with_payment
    if email && customer
      self[:customer_id] = customer.id
      save! if valid?
    end
  rescue Stripe::InvalidRequestError => e
    logger.error "Stripe error while creating customer: #{e.message}"
    errors.add :base, "There was a problem with your credit card."
    false
  end

  def update_payment
    update_stripe_card_with_new_token
    update! active: true
  rescue Stripe::InvalidRequestError => e
    logger.error "Stripe error while creating customer: #{e.message}"
    errors.add :base, "There was a problem with your credit card."
    false
  end

  def is_a_stripe_user?
    begin
      stripe_account.present?
    rescue Stripe::StripeError => e
      false
    end
  end

  private

    def customer
      @_customer ||= Stripe::Customer.create(
        description: email,
        plan: "idrivealot_monthly",
        card: stripe_card_token
      )
    end

    def stripe_account
      @_stripe_account ||= Stripe::Customer.retrieve(customer_id)
    end

    def update_stripe_card_with_new_token
      if is_a_stripe_user?
        stripe_account.card = stripe_card_token
        stripe_account.save
      end
    end

end
