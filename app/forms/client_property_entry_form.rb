class ClientPropertyEntryForm < BasePropertyEntryForm
  ATTRIBUTES = (BASE_ATTRIBUTES + %i[house_in_dispute]).freeze

  delegate :partner, :property_owned, :smod_applicable?, to: :check

  attribute :house_in_dispute, :boolean
  validates :house_in_dispute, inclusion: { in: [true, false] }, allow_nil: false, if: :smod_applicable?

  def owned_with_mortgage?
    property_owned == "with_mortgage"
  end
end
