class PartnerPropertyEntryForm < BasePropertyEntryForm
  include SessionPersistableForPartner

  ATTRIBUTES = BASE_ATTRIBUTES.freeze

  delegate :partner_property_owned, to: :check

  def owned_with_mortgage?
    partner_property_owned == "with_mortgage"
  end
end
