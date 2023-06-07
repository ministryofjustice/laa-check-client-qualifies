class DisputedAssetModel
  include ActiveModel::Model
  include ActiveModel::Attributes
  include SessionPersistable

  attribute :in_dispute, array: true, default: []
  attribute :house_in_dispute, :boolean
  attribute :additional_house_in_dispute, :boolean
  attribute :property_owned, :string
  attribute :additional_property_owned, :string
  attribute :vehicle_owned, :boolean

  ATTRIBUTES = %i[in_dispute
                  house_in_dispute
                  property_owned
                  additional_property_owned
                  vehicle_owned
                  additional_house_in_dispute].freeze

  def disputed?(field)
    case field
    when "savings"
      in_dispute.include? "savings"
    when "investments"
      in_dispute.include? "investments"
    when "valuables"
      in_dispute.include? "valuables"
    when "property_owned"
      owns_property? && house_in_dispute
    when "additional_property_owned"
      owns_additional_property? && additional_house_in_dispute
    else
      false
    end
  end

private

  def owns_property?
    PropertyForm::OWNED_OPTIONS.map(&:to_s).include? property_owned
  end

  def owns_additional_property?
    PropertyForm::OWNED_OPTIONS.map(&:to_s).include? additional_property_owned
  end
end
