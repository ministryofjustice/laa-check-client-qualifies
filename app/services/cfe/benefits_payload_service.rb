module Cfe
  class BenefitsPayloadService < BaseService
    def call
      benefits_form = BenefitDetailsForm.from_session(@session_data) if relevant_form?(:benefit_details)
      housing_benefit_details_form = HousingBenefitDetailsForm.from_session(@session_data) if relevant_form?(:housing_benefit_details)
      return if benefits_form&.items.blank? && !housing_benefit_details_form

      state_benefits = CfeParamBuilders::StateBenefits.call(benefits_form, housing_benefit_details_form)

      payload[:state_benefits] = state_benefits
    end
  end
end
