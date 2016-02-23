class MileageRecord < ActiveRecord::Base

  # create_table :mileage_records do |t|
  #   t.date :record_date
  #   t.integer :start_mileage
  #   t.integer :end_mileage
  #   t.string :route_description
  #   t.integer :distance
  #   t.text :notes
  #   t.references :user, index: true

  #   t.timestamps

  belongs_to :user

  attr_accessor :new_route_description

  validates :user, :record_date, :route_description, presence: true
  validates :start_mileage, numericality: { only_integer: true }, if: :start_mileage_present?
  validates :end_mileage, numericality: { only_integer: true }, if: :end_mileage_present?

  validate :start_less_than_end_mileage

  before_save :set_distance

  def record_date
    read_attribute(:record_date) || Date.today
  end

  def self.last_end_mileage_for(user)
    if MileageRecord.where(user: user).exists?
      MileageRecord.where(user: user).last.end_mileage
    else
      0
    end
  end

  def self.to_csv(user)
    CSV.generate do |csv|
      csv << column_names
      where(user: user).each do |record|
        csv << record.attributes.values_at(*column_names)
      end
    end
  end

  private

    def set_distance
      if read_attribute(:end_mileage).present?
        self[:distance] = read_attribute(:end_mileage) - read_attribute(:start_mileage)
      end
    end

    def start_less_than_end_mileage
      unless end_mileage.blank?
        if read_attribute(:end_mileage) < read_attribute(:start_mileage)
          errors[:base] << "End Mileage must be greater than Start Mileage"
        end
      end
    end

    def start_mileage_present?
      start_mileage.present?
    end

    def end_mileage_present?
      end_mileage.present?
    end
end
