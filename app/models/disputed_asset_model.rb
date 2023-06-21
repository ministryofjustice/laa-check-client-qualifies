class DisputedAssetModel
  include ActiveModel::Model
  include ActiveModel::Attributes
  include SessionPersistable

  attribute :house_in_dispute, :boolean
  attribute :additional_house_in_dispute, :boolean
  attribute :property_owned, :string
  attribute :additional_property_owned, :string

  ATTRIBUTES = %i[house_in_dispute
                  property_owned
                  additional_property_owned
                  additional_house_in_dispute].freeze

  def disputed?(field)
    case field
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
