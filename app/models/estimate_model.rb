class EstimateModel
  include ActiveModel::Model
  include ActiveModel::Attributes
  include SessionPersistable

  ESTIMATE_BOOLEANS = %i[upper_tribunal
                         over_60
                         passporting
                         vehicle_owned
                         vehicle_in_regular_use
                         partner
                         employed
                         partner_employed
                         partner_vehicle_owned
                         housing_benefit
                         partner_housing_benefit].freeze

  # This is the set of attributes which affect the page flow
  ATTRIBUTES = (ESTIMATE_BOOLEANS + %i[level_of_help property_owned partner_property_owned]).freeze

  ESTIMATE_BOOLEANS.each do |attr|
    attribute attr, :boolean
  end

  attribute :property_owned, :string
  attribute :partner_property_owned, :string

  # TODO: This should not be defaulted after :controlled flag removed
  attribute :level_of_help, :string, default: "certificated"

  def owns_property?
    %i[with_mortgage outright].map(&:to_s).include? property_owned
  end

  def partner_owns_property?
    %i[with_mortgage outright].map(&:to_s).include? partner_property_owned
  end

  def controlled?
    level_of_help == "controlled"
  end
end
