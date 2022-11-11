class VehicleForm
  include ActiveModel::Model
  include ActiveModel::Attributes

  ATTRIBUTES = [:vehicle_owned].freeze

  attribute :vehicle_owned, :boolean
  validates :vehicle_owned, inclusion: { in: [true, false], allow_nil: false }
end
