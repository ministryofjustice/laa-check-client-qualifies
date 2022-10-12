class VehicleValueForm
  include ActiveModel::Model
  include ActiveModel::Attributes

  VEHICLE_VALUE_ATTRIBUTES = %i[vehicle_value vehicle_in_regular_use].freeze

  attribute :vehicle_value, :gbp
  validates :vehicle_value,
            numericality: { greater_than: 0, allow_nil: true },
            presence: true

  attribute :vehicle_in_regular_use, :boolean
  validates :vehicle_in_regular_use, inclusion: { in: [true, false], allow_nil: false }
end
