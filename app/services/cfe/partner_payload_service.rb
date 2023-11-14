module Cfe
  class PartnerPayloadService < BaseService
    def call
      return unless relevant_form?(:partner_details)

      @partner_details_form = instantiate_form(PartnerDetailsForm)
      partner_financials = {
        partner:,
        irregular_incomes:,
        employment_details:,
        self_employment_details:,
        regular_transactions:,
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
        employed: check.partner_employed?,
      }
    end

    def irregular_incomes
      return [] unless relevant_form?(:partner_other_income)

      form = instantiate_form(PartnerOtherIncomeForm)
      CfeParamBuilders::IrregularIncome.call(form)
    end

    def employment_details
      return [] unless relevant_form?(:partner_income)

      form = PartnerIncomeForm.from_session(@session_data)
      CfeParamBuilders::Employment.call(form)
    end

    def self_employment_details
      return [] unless relevant_form?(:partner_income)

      form = PartnerIncomeForm.from_session(@session_data)
      CfeParamBuilders::SelfEmployment.call(form)
    end

    def regular_transactions
      return [] unless relevant_form?(:partner_other_income) && relevant_form?(:partner_outgoings)

      outgoings_form = instantiate_form(PartnerOutgoingsForm) if early_eligibility?
      income_form = instantiate_form(PartnerOtherIncomeForm)
      benefits_form = instantiate_form(PartnerBenefitDetailsForm) if relevant_form?(:partner_benefit_details)
      CfeParamBuilders::RegularTransactions.call(income_form, outgoings_form, benefits_form)
    end

    def additional_properties
      return [] unless relevant_form?(:partner_additional_property_details) && !early_eligibility?

      form = instantiate_form(PartnerAdditionalPropertyDetailsForm)
      form.items.map do |model|
        {
          value: model.house_value,
          outstanding_mortgage: (model.mortgage if model.owned_with_mortgage?) || 0,
          percentage_owned: model.percentage_owned,
          shared_with_housing_assoc: false,
        }
      end
    end

    def capitals
      return if early_eligibility?

      assets_form = instantiate_form(PartnerAssetsForm)
      CfeParamBuilders::Capitals.call(assets_form)
    end
  end
end
