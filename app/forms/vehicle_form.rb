class VehicleForm
  include ActiveModel::Model
  include ActiveModel::Attributes

  VEHICLE_ATTRIBUTES = [:vehicle_owned].freeze

  attribute :vehicle_owned, :boolean
  validates :vehicle_owned, inclusion: { in: [true, false], allow_nil: false }
end
