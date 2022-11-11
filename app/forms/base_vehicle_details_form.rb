class BaseVehicleDetailsForm
  include ActiveModel::Model
  include ActiveModel::Attributes

  ATTRIBUTES = %i[vehicle_finance
                  vehicle_pcp
                  vehicle_over_3_years_ago
                  vehicle_value
                  vehicle_in_regular_use].freeze

  attribute :vehicle_pcp, :boolean
  validates :vehicle_pcp, inclusion: { in: [true, false], allow_nil: false }

  attribute :vehicle_finance, :gbp
  validates :vehicle_finance,
            numericality: { greater_than: 0, allow_nil: true },
            presence: true, if: -> { vehicle_pcp }

  attribute :vehicle_over_3_years_ago, :boolean
  validates :vehicle_over_3_years_ago, inclusion: { in: [true, false], allow_nil: false }

  attribute :vehicle_value, :gbp
  validates :vehicle_value,
            numericality: { greater_than: 0, allow_nil: true },
            presence: true

  attribute :vehicle_in_regular_use, :boolean
  validates :vehicle_in_regular_use, inclusion: { in: [true, false], allow_nil: false }
end
