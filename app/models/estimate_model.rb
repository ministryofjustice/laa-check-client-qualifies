class EstimateModel
  include ActiveModel::Model
  include ActiveModel::Attributes

  ESTIMATE_BOOLEANS = %i[over_60
                         passporting
                         vehicle_owned
                         vehicle_in_regular_use
                         dependants
                         partner
                         employed
                         assets
                         savings
                         investments
                         vehicle_over_3_years_ago
                         vehicle_pcp].freeze

  # This is the set of attributes which affect the page flow
  ESTIMATE_ATTRIBUTES = (ESTIMATE_BOOLEANS + %i[property_owned
                                                dependant_count
                                                vehicle_value
                                                vehicle_finance
                                                house_value
                                                mortgage
                                                percentage_owned
                                                property_value
                                                property_mortgage
                                                property_percentage_owned]).freeze

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
  attribute :property_mortgage, :decimal
  attribute :property_percentage_owned, :integer

  def owned?
    %i[with_mortgage outright].map(&:to_s).include? property_owned
  end
end
