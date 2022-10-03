class EstimateModel
  include ActiveModel::Model
  include ActiveModel::Attributes

  ESTIMATE_BOOLEANS = %i[over_60 passporting vehicle_owned vehicle_in_regular_use].freeze

  # This is the set of attributes which affect the page flow
  ESTIMATE_ATTRIBUTES = (ESTIMATE_BOOLEANS + [:property_owned]).freeze

  ESTIMATE_BOOLEANS.each do |attr|
    attribute attr, :boolean
  end

  attribute :property_owned, :string
  attribute :dependants, :boolean
  attribute :dependant_count, :integer
  attribute :partner, :boolean
  attribute :employed, :boolean
  attribute :assets, :boolean
  attribute :savings, :boolean
  attribute :investments, :boolean

  attribute :vehicle_value, :decimal
  attribute :vehicle_over_3_years_ago, :boolean
  attribute :vehicle_pcp, :boolean
  attribute :vehicle_finance, :decimal

  attribute :house_value, :decimal
  attribute :mortgage, :decimal
  attribute :percentage_owned, :integer

  attribute :property_value, :decimal
  attribute :property_mortgage, :decimal
  attribute :property_percentage_owned, :integer

  def owned?
    %i[with_mortgage outright].map(&:to_s).include? property_owned
  end
end
