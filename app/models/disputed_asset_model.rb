class DisputedAssetModel
  include ActiveModel::Model
  include ActiveModel::Attributes
  include SessionPersistable

  attribute :in_dispute, array: true, default: []
  attribute :vehicle_in_dispute, :boolean
  attribute :house_in_dispute, :boolean
  attribute :property_owned, :string
  attribute :vehicle_owned, :boolean

  ATTRIBUTES = %i[in_dispute vehicle_in_dispute house_in_dispute property_owned vehicle_owned].freeze

  def disputed?(field)
    case field
    when "property_value"
      in_dispute.include? "property"
    when "savings"
      in_dispute.include? "savings"
    when "investments"
      in_dispute.include? "investments"
    when "valuables"
      in_dispute.include? "valuables"
    when "property_owned"
      owns_property? && house_in_dispute
    when "vehicle_owned"
      vehicle_owned && vehicle_in_dispute
    else
      false
    end
  end

private

  def owns_property?
    %i[with_mortgage outright].map(&:to_s).include? property_owned
  end
end
