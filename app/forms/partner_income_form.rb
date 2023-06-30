class PartnerIncomeForm < IncomeForm
  include SessionPersistableForPartner
  include AddAnotherable

  ITEMS_SESSION_KEY = "partner_incomes".freeze

  def self.add_extra_attributes_to_model_from_session(model, session_data)
    model.controlled = Steps::Logic.controlled?(session_data)
    model.partner = true
  end
end
