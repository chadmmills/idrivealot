class CreateMileageRecords < ActiveRecord::Migration
  def change
    create_table :mileage_records do |t|
      t.date :record_date
      t.integer :start_mileage
      t.integer :end_mileage
      t.string :route_description
      t.integer :distance
      t.text :notes
      t.references :user, index: true

      t.timestamps
    end
  end
end
