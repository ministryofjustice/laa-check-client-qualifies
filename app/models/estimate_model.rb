class EstimateModel
  include ActiveModel::Model
  include ActiveModel::Attributes

  ESTIMATE_BOOLEANS = %i[over_60
                         passporting
                         vehicle_owned
                         vehicle_in_regular_use
                         vehicle_over_3_years_ago
                         vehicle_pcp
                         employed
                         dependants
                         partner].freeze

  # This is the set of attributes which affect the page flow
  ESTIMATE_ATTRIBUTES = (ESTIMATE_BOOLEANS + [:property_owned]).freeze

  ESTIMATE_BOOLEANS.each do |attr|
    attribute attr, :boolean
  end

  attribute :property_owned, :string
  attribute :dependant_count, :integer
  attribute :vehicle_value, :decimal
  attribute :vehicle_finance, :decimal

  attribute :house_value, :decimal
  attribute :mortgage, :decimal
  attribute :percentage_owned, :integer

  attribute :property_value, :decimal
  attribute :savings, :decimal
  attribute :investments, :decimal
  attribute :valuables, :decimal
  attribute :property_mortgage, :decimal
  attribute :property_percentage_owned, :integer
  attribute :proceeding_type, :string

  attribute :assets, array: true, default: []

  def owned?
    %i[with_mortgage outright].map(&:to_s).include? property_owned
  end
end
