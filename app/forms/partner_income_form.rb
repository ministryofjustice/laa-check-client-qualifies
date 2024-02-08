class PartnerIncomeForm < IncomeForm
  include SessionPersistableForPartner
  include AddAnotherable

  ITEMS_SESSION_KEY = "partner_incomes".freeze
  ITEM_MODEL = PartnerIncomeModel

  class << self
    def param_key
      "income_model"
    end

    def add_extra_attributes_to_model_from_session(model, session_data, _)
      model.controlled = Steps::Logic::Thing.new(session_data).controlled?
      model.partner = true
    end
  end
end
