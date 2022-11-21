class SubmitPartnerService < BaseCfeService
  def call(cfe_estimate_id, cfe_session_data)
    @cfe_session_data = cfe_session_data
    form = PartnerForm.from_session(cfe_session_data)
    return unless form.partner

    cfe_connection.create_partner cfe_estimate_id,
                                  partner:,
                                  irregular_incomes:,
                                  employments:,
                                  regular_transactions:,
                                  state_benefits:,
                                  additional_properties:,
                                  capitals:,
                                  vehicles:
  end

  def partner
    @partner ||= begin
      form = ApplicantForm.from_session(@cfe_session_data)
      {
        date_of_birth: form.partner_over_60 ? 70.years.ago.to_date : 50.years.ago.to_date,
        employed: form.partner_employed,
      }
    end
  end

  def irregular_incomes
    form = PartnerOtherIncomeForm.from_session(@cfe_session_data)
    CfeParamBuilders::IrregularIncome.call(form)
  end

  def employments
    return [] unless partner[:employed]

    form = PartnerEmploymentForm.from_session(@cfe_session_data)
    CfeParamBuilders::Employments.call(form)
  end

  def regular_transactions
    outgoings_form = PartnerOutgoingsForm.from_session(@cfe_session_data)
    income_form = PartnerOtherIncomeForm.from_session(@cfe_session_data)
    CfeParamBuilders::RegularTransactions.call(income_form, outgoings_form)
  end

  def state_benefits
    form = PartnerBenefitsForm.from_session(@cfe_session_data)
    return [] if form.benefits.blank?

    CfeParamBuilders::StateBenefits.call(form)
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
end
