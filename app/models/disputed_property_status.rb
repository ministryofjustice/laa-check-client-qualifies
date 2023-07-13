class DisputedPropertyStatus
  include ActiveModel::Model
  include ActiveModel::Attributes
  include SessionPersistable

  attribute :house_in_dispute, :boolean
  attribute :property_owned, :string

  ATTRIBUTES = %i[house_in_dispute
                  property_owned].freeze

  def disputed?(field)
    return false unless field == "property_owned"

    owns_property? && house_in_dispute
  end

private

  def owns_property?
    PropertyForm::OWNED_OPTIONS.map(&:to_s).include? property_owned
  end
end
