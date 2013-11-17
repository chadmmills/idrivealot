json.array!(@mileage_records) do |mileage_record|
  json.extract! mileage_record, :record_date, :start_mileage, :end_mileage, :route_description, :distance, :notes, :user_id
  json.url mileage_record_url(mileage_record, format: :json)
end
