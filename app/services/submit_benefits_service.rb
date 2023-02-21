class SubmitBenefitsService < BaseCfeService
  def call(cfe_assessment_id, session_data)
    benefits_form = BenefitsForm.from_session(session_data)
    housing_benefit_form = HousingBenefitForm.from_session(session_data)
    return if benefits_form.benefits.blank? && !housing_benefit_form.housing_benefit

    housing_benefit_details_form = HousingBenefitDetailsForm.from_session(session_data) if housing_benefit_form.housing_benefit
    state_benefits = CfeParamBuilders::StateBenefits.call(benefits_form, housing_benefit_details_form)

    cfe_connection.create_benefits(cfe_assessment_id, state_benefits)
  end
end
