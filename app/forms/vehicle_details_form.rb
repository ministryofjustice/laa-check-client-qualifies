class VehicleDetailsForm < BaseVehicleDetailsForm
  ATTRIBUTES = %i[vehicle_finance
                  vehicle_pcp
                  vehicle_over_3_years_ago
                  vehicle_value
                  vehicle_in_regular_use
                  vehicle_in_dispute].freeze

  attribute :vehicle_in_dispute, :boolean
  validates :vehicle_in_dispute, inclusion: { in: [true, false], allow_nil: false }
end
