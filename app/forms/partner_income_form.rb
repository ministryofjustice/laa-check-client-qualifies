class PartnerIncomeForm < IncomeForm
  SESSION_KEY = "partner_incomes".freeze

  def self.add_session_attributes(form, session_data)
    form.controlled = Steps::Logic.controlled?(session_data)
    form.partner = true
  end
end
