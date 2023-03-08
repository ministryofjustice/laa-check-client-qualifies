class SubmitBenefitsService < BaseCfeService
  def call(cfe_assessment_id)
    benefits_form = BenefitsForm.from_session(@session_data) if relevant_form?(:benefits)
    housing_benefit_details_form = HousingBenefitDetailsForm.from_session(@session_data) if relevant_form?(:housing_benefit_details)
    return if benefits_form&.benefits.blank? && !housing_benefit_details_form

    state_benefits = CfeParamBuilders::StateBenefits.call(benefits_form, housing_benefit_details_form)

    cfe_connection.create_state_benefits(cfe_assessment_id, state_benefits)
  end
end
