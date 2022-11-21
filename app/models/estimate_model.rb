class EstimateModel
  include ActiveModel::Model
  include ActiveModel::Attributes
  include SessionPersistable

  ESTIMATE_BOOLEANS = %i[over_60
                         passporting
                         vehicle_owned
                         vehicle_in_regular_use
                         partner
                         employed
                         dependants
                         partner_employed
                         partner_vehicle_owned].freeze

  # This is the set of attributes which affect the page flow
  ATTRIBUTES = (ESTIMATE_BOOLEANS + %i[property_owned]).freeze

  ESTIMATE_BOOLEANS.each do |attr|
    attribute attr, :boolean
  end

  attribute :property_owned, :string

  def owned?
    %i[with_mortgage outright].map(&:to_s).include? property_owned
  end
end
