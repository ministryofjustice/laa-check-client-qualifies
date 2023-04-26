class ClientVehicleDetailsForm < BaseVehicleDetailsForm
  ATTRIBUTES = (BASE_ATTRIBUTES + %i[vehicle_in_dispute]).freeze

  delegate :smod_applicable?, to: :check

  attribute :vehicle_in_dispute, :boolean
  validates :vehicle_in_dispute, inclusion: { in: [true, false], allow_nil: false }, if: :smod_applicable?
end
