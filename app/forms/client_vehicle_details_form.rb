class ClientVehicleDetailsForm < BaseVehicleDetailsForm
  ATTRIBUTES = (BASE_ATTRIBUTES + %i[vehicle_in_dispute]).freeze

  attribute :vehicle_in_dispute, :boolean
end
