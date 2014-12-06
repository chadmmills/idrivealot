class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :mileage_records

  attr_accessor :stripe_card_token

  validates :customer_id, presence: true

  def save_with_payment
    if email
      customer = Stripe::Customer.create(description: email,
                                         plan: "idrivealot_monthly",
                                         card: stripe_card_token)
      self.customer_id = customer.id
      save! if valid?
    end
  rescue Stripe::InvalidRequestError => e
    logger.error "Stripe error while creating customer: #{e.message}"
    errors.add :base, "There was a problem with your credit card."
    false
  end

  def update_payment
    customer = Stripe::Customer.retrieve(customer_id)
    customer.card = stripe_card_token
    customer.save
    self.active = true
    save! if valid?
  rescue Stripe::InvalidRequestError => e
    logger.error "Stripe error while creating customer: #{e.message}"
    errors.add :base, "There was a problem with your credit card."
    false
  end

end
