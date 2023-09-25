class PartnerBenefitDetailsForm < BenefitDetailsForm
  include SessionPersistableForPartner
  include AddAnotherable
  ITEM_MODEL = PartnerBenefitModel
  ITEMS_SESSION_KEY = "partner_benefits".freeze
  class << self
    def param_key
      "benefit_model"
    end
  end
end
