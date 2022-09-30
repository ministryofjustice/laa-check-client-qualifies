class VehicleFinanceForm
  include ActiveModel::Model
  include ActiveModel::Attributes

  VEHICLE_FINANCE_ATTRIBUTES = %i[vehicle_finance vehicle_pcp].freeze

  attribute :vehicle_pcp, :boolean
  validates :vehicle_pcp, inclusion: { in: [true, false], allow_nil: false }

  attribute :vehicle_finance, :decimal
  validates :vehicle_finance,
            numericality: { greater_than: 0, allow_nil: true },
            presence: true, if: -> { vehicle_pcp }
end
