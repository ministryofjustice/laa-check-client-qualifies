class EstimateData
  include ActiveModel::Model
  include ActiveModel::Attributes

  ESTIMATE_ATTRIBUTES = %i[over_60 passporting property_owned employed].freeze

  attribute :over_60, :boolean
  attribute :passporting, :boolean
  attribute :property_owned, :string
  attribute :employed, :boolean

  def owned?
    %i[with_mortgage outright].map(&:to_s).include? property_owned
  end
end
