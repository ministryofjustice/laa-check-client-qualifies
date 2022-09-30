class EstimateData
  include ActiveModel::Model
  include ActiveModel::Attributes

  ESTIMATE_BOOLEANS = %i[over_60 passporting vehicle_owned vehicle_in_regular_use].freeze

  # This is the set of attributes which affect the page flow
  ESTIMATE_ATTRIBUTES = (ESTIMATE_BOOLEANS + %i[property_owned employed]).freeze

  ESTIMATE_BOOLEANS.each do |attr|
    attribute attr, :boolean
  end

  attribute :property_owned, :string
  attribute :employed, :boolean

  def owned?
    %i[with_mortgage outright].map(&:to_s).include? property_owned
  end
end
