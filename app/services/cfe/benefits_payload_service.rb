module Cfe
  class BenefitsPayloadService < BaseService
    def call
      benefits_form = instantiate_form(BenefitDetailsForm) if relevant_form?(:benefit_details)
      housing_benefit_from_housing_costs_form = instantiate_form(HousingCostsForm) if relevant_form?(:housing_costs)
      return if benefits_form&.items.blank? && !housing_benefit_from_housing_costs_form

      state_benefits = CfeParamBuilders::StateBenefits.call(benefits_form, housing_benefit_from_housing_costs_form)

      payload[:state_benefits] = state_benefits
    end
  end
end
