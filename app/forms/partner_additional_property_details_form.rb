class PartnerAdditionalPropertyDetailsForm < AdditionalPropertyDetailsForm
  include SessionPersistableForPartner
  include AddAnotherable
  ITEM_MODEL = PartnerAdditionalPropertyModel
  ITEMS_SESSION_KEY = "partner_additional_properties".freeze

  class << self
    def param_key
      "additional_property_model"
    end

    def add_extra_attributes_to_model_from_session(model, session_data, index)
      check = Check.new(session_data)
      model.smod_applicable = false
      model.ownership_status = check.partner_additional_property_owned if index.zero?
    end
  end
end
