class SubmitOutgoingsService < CfeService
  def self.call(cfe_estimate_id, cfe_session_data)
    new.call(cfe_estimate_id, cfe_session_data)
  end

  def call(cfe_estimate_id, cfe_session_data)
    form = Flow::OutgoingsHandler.model(cfe_session_data)
    income_form = Flow::MonthlyIncomeHandler.model(cfe_session_data)

    cfe_connection.create_regular_payments(cfe_estimate_id, income_form, form)
  end
end
