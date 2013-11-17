require 'spec_helper'

    # create_table :mileage_records do |t|
    #   t.date :record_date
    #   t.integer :start_mileage
    #   t.integer :end_mileage
    #   t.string :route_description
    #   t.integer :distance
    #   t.text :notes
    #   t.references :user, index: true

    #   t.timestamps

describe MileageRecord do
	it "has an invalid date" do
  	expect(build(:mileage_record, record_date: nil)).to have(1).errors_on(:record_date)
  end

  it " has an invalid route" do
  	expect(build(:mileage_record, route_description: nil)).to have(1).errors_on(:route_description)
  end

  it "has an invalid mileage value" do
  	expect(build(:mileage_record, start_mileage: 1.34)).to have(1).errors_on(:start_mileage)
  end

  it "has a valid mileage value" do
  	expect(build(:mileage_record, start_mileage: 1024)).to have(0).errors_on(:start_mileage)
  end

  it "has an invalid mileage value" do
  	expect(build(:mileage_record, end_mileage: 1.024)).to have(1).errors_on(:end_mileage)
  end

  it "is a valid record" do
    expect(create(:mileage_record)).to be_valid
  end

  it "saves the distance of the trip" do
    record = create(:mileage_record, start_mileage: 5, end_mileage: 10)
    expect(record.distance).to eq(5)
  end

  it "is invalid due to start_mileage > end_mileage" do
    expect(build(:mileage_record, start_mileage: 15, end_mileage: 10)).to be_invalid
  end
end
