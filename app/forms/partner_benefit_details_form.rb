class PartnerBenefitDetailsForm < BenefitDetailsForm
  include SessionPersistableForPartner
  include AddAnotherable

  ITEMS_SESSION_KEY = "partner_benefits".freeze
end
