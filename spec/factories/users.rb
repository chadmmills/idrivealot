# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
  	sequence(:email) { |n| "tracker#{n}@aldi.com" }
    sequence(:customer_id) { |n| "ZSRF345KGMIEKSO#{n}" }
  	password "password"
  	password_confirmation "password"
  end
end
