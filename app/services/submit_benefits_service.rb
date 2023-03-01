class SubmitBenefitsService < BaseCfeService
  def call(cfe_assessment_id)
    benefits_form = BenefitsForm.from_session(@session_data) if relevant_form?(:benefits)
    housing_form = HousingForm.from_session(@session_data) if relevant_form?(:housing)
    return if benefits_form&.benefits.blank? && !housing_form&.receives_housing_benefit

    state_benefits = CfeParamBuilders::StateBenefits.call(benefits_form, housing_form)

    cfe_connection.create_benefits(cfe_assessment_id, state_benefits)
  end
end
