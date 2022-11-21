class ClientVehicleDetailsForm < BaseVehicleDetailsForm
  ATTRIBUTES = (BASE_ATTRIBUTES + %i[vehicle_in_dispute]).freeze

  attribute :vehicle_in_dispute, :boolean
  validates :vehicle_in_dispute, inclusion: { in: [true, false], allow_nil: false }
end
