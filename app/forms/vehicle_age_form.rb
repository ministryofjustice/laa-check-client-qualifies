class VehicleAgeForm
  include ActiveModel::Model
  include ActiveModel::Attributes

  VEHICLE_AGE_ATTRIBUTES = [:vehicle_over_3_years_ago].freeze

  attribute :vehicle_over_3_years_ago, :boolean
  validates :vehicle_over_3_years_ago, inclusion: { in: [true, false], allow_nil: false }
end
