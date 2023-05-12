module Cfe
  class PartnerPayloadService < BaseService
    def call
      return unless relevant_form?(:partner_details)

      @partner_details_form = PartnerDetailsForm.from_session(@session_data)
      partner_financials = {
        partner:,
        irregular_incomes:,
        employments:,
        regular_transactions:,
        state_benefits:,
        additional_properties:,
        capitals:,
        dependants:,
        vehicles:,
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

      form = PartnerOtherIncomeForm.from_session(@session_data)
      CfeParamBuilders::IrregularIncome.call(form)
    end

    def employments
      return [] unless relevant_form?(:partner_employment)

      form = PartnerEmploymentForm.from_session(@session_data)
      CfeParamBuilders::Employments.call(form, @partner_details_form)
    end

    def regular_transactions
      return [] unless relevant_form?(:partner_other_income) && relevant_form?(:partner_outgoings)

      outgoings_form = PartnerOutgoingsForm.from_session(@session_data)
      income_form = PartnerOtherIncomeForm.from_session(@session_data)
      CfeParamBuilders::RegularTransactions.call(income_form, outgoings_form)
    end

    def state_benefits
      benefits_form = PartnerBenefitDetailsForm.from_session(@session_data) if relevant_form?(:partner_benefit_details)
      housing_benefit_details_form = PartnerHousingBenefitDetailsForm.from_session(@session_data) if relevant_form?(:partner_housing_benefit_details)
      return [] if benefits_form&.items.blank? && !housing_benefit_details_form

      CfeParamBuilders::StateBenefits.call(benefits_form, housing_benefit_details_form)
    end

    def additional_properties
      return legacy_additional_properties unless relevant_form?(:partner_additional_property_details)

      additional_property = PartnerAdditionalPropertyDetailsForm.from_session(@session_data)
      [{
        value: additional_property.house_value,
        outstanding_mortgage: (additional_property.mortgage if additional_property.owned_with_mortgage?) || 0,
        percentage_owned: additional_property.percentage_owned,
        shared_with_housing_assoc: false,
      }]
    end

    def legacy_additional_properties
      form = PartnerAssetsForm.from_session(@session_data)
      return [] unless form.property_value&.positive?

      [{
        value: form.property_value,
        outstanding_mortgage: form.property_mortgage,
        percentage_owned: form.property_percentage_owned,
        shared_with_housing_assoc: false,
      }]
    end

    def capitals
      assets_form = PartnerAssetsForm.from_session(@session_data)
      CfeParamBuilders::Capitals.call(assets_form)
    end

    def vehicles
      return [] unless relevant_form?(:partner_vehicle_details)

      details_model = PartnerVehicleDetailsForm.from_session(@session_data)
      CfeParamBuilders::Vehicles.call([details_model])
    end

    def dependants
      return [] unless relevant_form?(:partner_dependant_details)

      details_form = PartnerDependantDetailsForm.from_session(@session_data)
      children = CfeParamBuilders::Dependants.children(dependants: details_form.child_dependants,
                                                       count: details_form.child_dependants_count)
      adults = CfeParamBuilders::Dependants.adults(dependants: details_form.adult_dependants,
                                                   count: details_form.adult_dependants_count)
      children + adults
    end
  end
end
