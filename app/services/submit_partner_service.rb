class SubmitPartnerService < BaseCfeService
  def call(cfe_estimate_id, cfe_session_data)
    @cfe_session_data = cfe_session_data
    @applicant_form = ApplicantForm.from_session(cfe_session_data)
    return unless Flipper.enabled?(:partner) && @applicant_form.partner

    cfe_connection.create_partner cfe_estimate_id,
                                  partner:,
                                  irregular_incomes:,
                                  employments:,
                                  regular_transactions:,
                                  state_benefits:,
                                  additional_properties:,
                                  capitals:,
                                  dependants:,
                                  vehicles:
  end

  def partner
    @partner ||= begin
      form = PartnerDetailsForm.from_session(@cfe_session_data)
      {
        date_of_birth: form.over_60 ? 70.years.ago.to_date : 50.years.ago.to_date,
        employed: !!form.employed,
      }
    end
  end

  def irregular_incomes
    form = PartnerOtherIncomeForm.from_session(@cfe_session_data)
    CfeParamBuilders::IrregularIncome.call(form)
  end

  def employments
    return [] unless partner[:employed] && !@applicant_form.passporting

    form = PartnerEmploymentForm.from_session(@cfe_session_data)
    CfeParamBuilders::Employments.call(form)
  end

  def regular_transactions
    outgoings_form = PartnerOutgoingsForm.from_session(@cfe_session_data)
    income_form = PartnerOtherIncomeForm.from_session(@cfe_session_data)
    CfeParamBuilders::RegularTransactions.call(income_form, outgoings_form)
  end

  def state_benefits
    benefits_form = PartnerBenefitsForm.from_session(@cfe_session_data)
    housing_benefit_form = PartnerHousingBenefitForm.from_session(@cfe_session_data)
    return [] if benefits_form.benefits.blank? && !housing_benefit_form.housing_benefit

    if housing_benefit_form.housing_benefit
      housing_benefit_details_form = PartnerHousingBenefitDetailsForm.from_session(@cfe_session_data)
    end

    CfeParamBuilders::StateBenefits.call(benefits_form, housing_benefit_details_form)
  end

  def additional_properties
    form = PartnerAssetsForm.from_session(@cfe_session_data)
    return [] unless form.property_value.positive?

    [{
      value: form.property_value,
      outstanding_mortgage: form.property_mortgage,
      percentage_owned: form.property_percentage_owned,
      shared_with_housing_assoc: false,
    }]
  end

  def capitals
    assets_form = PartnerAssetsForm.from_session(@cfe_session_data)
    CfeParamBuilders::Capitals.call(assets_form)
  end

  def vehicles
    owned_model = PartnerVehicleForm.from_session(@cfe_session_data)
    return [] unless owned_model.vehicle_owned

    details_model = PartnerVehicleDetailsForm.from_session(@cfe_session_data)
    CfeParamBuilders::Vehicles.call(details_model)
  end

  def dependants
    details_form = PartnerDependantDetailsForm.from_session(@cfe_session_data)
    children = CfeParamBuilders::Dependants.children(dependants: details_form.child_dependants,
                                                     count: details_form.child_dependants_count)
    adults = CfeParamBuilders::Dependants.adults(dependants: details_form.adult_dependants,
                                                 count: details_form.adult_dependants_count)
    children + adults
  end
end
