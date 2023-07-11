class PartnerAdditionalPropertyDetailsForm < AdditionalPropertyDetailsForm
  PREFIX = "partner_additional_".freeze

  ATTRIBUTES = %i[house_value mortgage percentage_owned].freeze

  delegate :partner_additional_property_owned, to: :check

  def owned_with_mortgage?
    partner_additional_property_owned == "with_mortgage"
  end

  def client_form_variant?
    false
  end
end
