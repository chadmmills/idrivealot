# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :mileage_record do
    record_date "2013-11-03"
    start_mileage 0
    end_mileage 243
    route_description "Store 91 to Store 89"
    notes "Going to do something to turn in something for the meeting next something"
    association :user

    factory :invalid_mileage_record do
    	record_date nil
    end
  end
end
