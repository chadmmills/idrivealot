FactoryGirl.define do
  factory :admin do
    sequence(:email) { |n| "email#{n}@idrivealot.com" }
    password "password123"
  end

end
