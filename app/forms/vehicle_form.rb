class VehicleForm
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :vehicle_owned, :boolean
  validates :vehicle_owned, inclusion: { in: [true, false] }
end
