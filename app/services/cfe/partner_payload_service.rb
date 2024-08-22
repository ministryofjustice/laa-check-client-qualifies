module Cfe
  class PartnerPayloadService < BaseService
    def call
      return unless check.has_partner_details?

      @partner_details_form = instantiate_form(PartnerDetailsForm)
      partner_financials = {
        partner:,
        irregular_incomes:,
        employment_details:,
        self_employment_details:,
        regular_transactions:,
        additional_properties:,
        dependants: [],
        vehicles: [],
      }
      partner_financials[:capitals] = capitals
      payload[:partner] = partner_financials
    end

    def partner
      @partner ||= {
        date_of_birth: @partner_details_form.over_60 ? 70.years.ago.to_date : 50.years.ago.to_date,
        employed: check.partner_employed?,
      }
    end

    def irregular_incomes
      return [] unless check.has_partner_other_income?

      form = instantiate_form(PartnerOtherIncomeForm)
      CfeParamBuilders::IrregularIncome.call(form)
    end

    def employment_details
      return [] unless check.partner_employed?

      form = PartnerIncomeForm.from_session(@session_data)
      CfeParamBuilders::Employment.call(form)
    end

    def self_employment_details
      return [] unless check.partner_employed?

      form = PartnerIncomeForm.from_session(@session_data)
      CfeParamBuilders::SelfEmployment.call(form)
    end

    def regular_transactions
      if check.has_partner_other_income? || check.has_partner_outgoings?
        outgoings_form = instantiate_form(PartnerOutgoingsForm) if check.has_partner_outgoings?
        income_form = instantiate_form(PartnerOtherIncomeForm) if check.has_partner_other_income?
        benefits_form = instantiate_form(PartnerBenefitDetailsForm) if check.has_partner_benefits?
        CfeParamBuilders::RegularTransactions.call(income_form, outgoings_form, benefits_form)
      else
        []
      end
    end

    def additional_properties
      return [] unless check.partner_owns_additional_property?

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
      assets_form = instantiate_form(PartnerAssetsForm)
      CfeParamBuilders::Capitals.call(assets_form)
    end
  end
end
