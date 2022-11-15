class SubmitBenefitsService < BaseCfeService
  def call(cfe_estimate_id, cfe_session_data)
    form = BenefitsForm.from_session(cfe_session_data)
    return if form.benefits.blank?

    state_benefits = CfeParamBuilders::StateBenefits.call(form)

    cfe_connection.create_benefits(cfe_estimate_id, state_benefits)
  end
end
