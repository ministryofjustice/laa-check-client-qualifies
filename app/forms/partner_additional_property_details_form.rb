class PartnerAdditionalPropertyDetailsForm < BasePropertyEntryForm
  include SessionPersistableWithPrefix
  PREFIX = "partner_additional_".freeze

  ATTRIBUTES = BASE_ATTRIBUTES

  delegate :partner_additional_property_owned, to: :check

  def owned_with_mortgage?
    partner_additional_property_owned == "with_mortgage"
  end
end
