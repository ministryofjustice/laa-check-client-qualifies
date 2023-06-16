module Cfe
  class PartnerPayloadService < BaseService
    def call
      return unless relevant_form?(:partner_details)

      @partner_details_form = instantiate_form(PartnerDetailsForm)
      partner_financials = {
        partner:,
        irregular_incomes:,
        employments:,
        employment:,
        self_employment:,
        regular_transactions:,
        state_benefits:,
        additional_properties:,
        capitals:,
        dependants: [],
        vehicles: [],
      }
      payload[:partner] = partner_financials
    end

    def partner
      @partner ||= {
        date_of_birth: @partner_details_form.over_60 ? 70.years.ago.to_date : 50.years.ago.to_date,
        employed: @partner_details_form.employment_status&.in?(ApplicantForm::EMPLOYED_STATUSES.map(&:to_s)) || false,
      }
    end

    def irregular_incomes
      return [] unless relevant_form?(:partner_other_income)

      form = instantiate_form(PartnerOtherIncomeForm)
      CfeParamBuilders::IrregularIncome.call(form)
    end

    def employments
      return [] unless relevant_form?(:partner_employment)

      form = instantiate_form(PartnerEmploymentForm)
      CfeParamBuilders::EmploymentIncomes.call(form, @partner_details_form)
    end

    def employment
      return [] unless relevant_form?(:partner_income)

      form = PartnerIncomeForm.from_session(@session_data)
      CfeParamBuilders::Employment.call(form)
    end

    def self_employment
      return [] unless relevant_form?(:partner_income)

      form = PartnerIncomeForm.from_session(@session_data)
      CfeParamBuilders::SelfEmployment.call(form)
    end

    def regular_transactions
      return [] unless relevant_form?(:partner_other_income) && relevant_form?(:partner_outgoings)

      outgoings_form = instantiate_form(PartnerOutgoingsForm)
      income_form = instantiate_form(PartnerOtherIncomeForm)
      CfeParamBuilders::PartnerRegularTransactions.call(income_form, outgoings_form)
    end

    def state_benefits
      benefits_form = instantiate_form(PartnerBenefitDetailsForm) if relevant_form?(:partner_benefit_details)
      return [] if benefits_form&.items.blank?

      CfeParamBuilders::StateBenefits.call(benefits_form)
    end

    def additional_properties
      return [] unless relevant_form?(:partner_additional_property_details)

      additional_property = instantiate_form(PartnerAdditionalPropertyDetailsForm)
      [{
        value: additional_property.house_value,
        outstanding_mortgage: (additional_property.mortgage if additional_property.owned_with_mortgage?) || 0,
        percentage_owned: additional_property.percentage_owned,
        shared_with_housing_assoc: false,
      }]
    end

    def capitals
      assets_form = instantiate_form(PartnerAssetsForm)
      CfeParamBuilders::Capitals.call(assets_form)
    end
  end
end
