class VehicleModel
  include ActiveModel::Model
  include ActiveModel::Attributes

  ATTRIBUTES = %i[vehicle_owned
                  vehicle_value
                  vehicle_in_regular_use
                  vehicle_over_3_years_ago
                  vehicle_pcp
                  vehicle_finance].freeze

  attribute :vehicle_owned, :boolean
  validates :vehicle_owned, inclusion: { in: [true, false], allow_nil: false }

  attribute :vehicle_value, :decimal
  validates :vehicle_value,
            numericality: { greater_than: 0, allow_nil: true },
            presence: true, if: -> { vehicle_owned }

  attribute :vehicle_in_regular_use, :boolean
  validates :vehicle_in_regular_use, inclusion: { in: [true, false], allow_nil: false }, if: -> { vehicle_owned }

  attribute :vehicle_over_3_years_ago, :boolean
  validates :vehicle_over_3_years_ago, inclusion: { in: [true, false], allow_nil: false }, if: -> { vehicle_in_regular_use }

  attribute :vehicle_pcp, :boolean
  validates :vehicle_pcp,
            inclusion: { in: [true, false], allow_nil: false },
            if: -> { vehicle_in_regular_use }

  attribute :vehicle_finance, :decimal
  validates :vehicle_finance,
            numericality: { greater_than: 0, allow_nil: true },
            presence: true, if: -> { vehicle_pcp }

  class << self
    def load_from_session(session_data)
      new session_data.slice(*ATTRIBUTES.map(&:to_s))
    end
  end
end
