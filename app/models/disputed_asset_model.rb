class DisputedAssetModel
  include ActiveModel::Model
  include ActiveModel::Attributes
  include SessionPersistable

  attribute :savings_in_dispute, :boolean
  attribute :investments_in_dispute, :boolean
  attribute :valuables_in_dispute, :boolean
  attribute :house_in_dispute, :boolean
  attribute :additional_house_in_dispute, :boolean
  attribute :property_owned, :string
  attribute :additional_property_owned, :string
  attribute :vehicle_owned, :boolean

  ATTRIBUTES = %i[savings_in_dispute
                  investments_in_dispute
                  valuables_in_dispute
                  house_in_dispute
                  property_owned
                  additional_property_owned
                  vehicle_owned
                  additional_house_in_dispute].freeze

  def disputed?(field)
    case field
    when "savings"
      savings_in_dispute
    when "investments"
      investments_in_dispute
    when "valuables"
      valuables_in_dispute
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
