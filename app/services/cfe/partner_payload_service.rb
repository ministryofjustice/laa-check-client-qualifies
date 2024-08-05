module Cfe
  class PartnerPayloadService
    class << self
      def call(session_data, payload, relevant_steps)
        return unless BaseService.completed_form?(relevant_steps, :partner_details)

        partner_details_form = BaseService.instantiate_form(session_data, PartnerDetailsForm)
        check = Check.new session_data
        partner_financials = {
          partner: partner(partner_details_form, check),
          irregular_incomes: irregular_incomes(session_data, relevant_steps),
          employment_details: employment_details(session_data, relevant_steps),
          self_employment_details: self_employment_details(session_data, relevant_steps),
          regular_transactions: regular_transactions(session_data, relevant_steps),
          additional_properties: additional_properties(session_data, relevant_steps),
          dependants: [],
          vehicles: [],
        }
        partner_financials[:capitals] = capitals(session_data, relevant_steps) if capitals(session_data, relevant_steps)
        payload[:partner] = partner_financials
      end

      def partner(partner_details_form, check)
        {
          date_of_birth: partner_details_form.over_60 ? 70.years.ago.to_date : 50.years.ago.to_date,
          employed: check.partner_employed?,
        }
      end

      def irregular_incomes(session_data, relevant_steps)
        return [] unless BaseService.completed_form?(relevant_steps, :partner_other_income)

        form = BaseService.instantiate_form(session_data, PartnerOtherIncomeForm)
        CfeParamBuilders::IrregularIncome.call(form)
      end

      def employment_details(session_data, relevant_steps)
        return [] unless BaseService.completed_form?(relevant_steps, :partner_income)

        form = PartnerIncomeForm.from_session(session_data)
        CfeParamBuilders::Employment.call(form)
      end

      def self_employment_details(session_data, relevant_steps)
        return [] unless BaseService.completed_form?(relevant_steps, :partner_income)

        form = PartnerIncomeForm.model_from_session(session_data)
        CfeParamBuilders::SelfEmployment.call(form)
      end

      def regular_transactions(session_data, relevant_steps)
        return [] if !BaseService.completed_form?(relevant_steps, :partner_other_income) && !BaseService.completed_form?(relevant_steps, :partner_outgoings)

        outgoings_form = BaseService.instantiate_form(session_data, PartnerOutgoingsForm) if BaseService.completed_form?(relevant_steps, :partner_outgoings)
        income_form = BaseService.instantiate_form(session_data, PartnerOtherIncomeForm) if BaseService.completed_form?(relevant_steps, :partner_other_income)
        benefits_form = BaseService.instantiate_form(session_data, PartnerBenefitDetailsForm) if BaseService.completed_form?(relevant_steps, :partner_benefit_details)
        CfeParamBuilders::RegularTransactions.call(income_form, outgoings_form, benefits_form)
      end

      def additional_properties(session_data, relevant_steps)
        return [] unless BaseService.completed_form?(relevant_steps, :partner_additional_property_details)

        form = BaseService.instantiate_form(session_data, PartnerAdditionalPropertyDetailsForm)
        form.items.map do |model|
          {
            value: model.house_value,
            outstanding_mortgage: (model.mortgage if model.owned_with_mortgage?) || 0,
            percentage_owned: model.percentage_owned,
            shared_with_housing_assoc: false,
          }
        end
      end

      def capitals(session_data, relevant_steps)
        return unless BaseService.completed_form?(relevant_steps, :partner_assets)

        assets_form = BaseService.instantiate_form(session_data, PartnerAssetsForm)
        CfeParamBuilders::Capitals.call(assets_form)
      end
    end
  end
end
