class SubmitPartnerService < BaseCfeService
  def call(cfe_assessment_id)
    return unless relevant_form?(:partner_details)

    cfe_connection.create_partner cfe_assessment_id,
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
      form = PartnerDetailsForm.from_session(@session_data)
      {
        date_of_birth: form.over_60 ? 70.years.ago.to_date : 50.years.ago.to_date,
        employed: form.employed || false,
      }
    end
  end

  def irregular_incomes
    return [] unless relevant_form?(:partner_other_income)

    form = PartnerOtherIncomeForm.from_session(@session_data)
    CfeParamBuilders::IrregularIncome.call(form)
  end

  def employments
    return [] unless relevant_form?(:partner_employment)

    form = PartnerEmploymentForm.from_session(@session_data)
    CfeParamBuilders::Employments.call(form)
  end

  def regular_transactions
    return [] unless relevant_form?(:partner_other_income) && relevant_form?(:partner_outgoings)

    outgoings_form = PartnerOutgoingsForm.from_session(@session_data)
    income_form = PartnerOtherIncomeForm.from_session(@session_data)
    CfeParamBuilders::RegularTransactions.call(income_form, outgoings_form)
  end

  def state_benefits
    benefits_form = PartnerBenefitsForm.from_session(@session_data) if relevant_form?(:partner_benefits)
    return [] if benefits_form&.benefits.blank?

    CfeParamBuilders::StateBenefits.call(benefits_form)
  end

  def additional_properties
    form = PartnerAssetsForm.from_session(@session_data)
    return [] unless form.property_value.positive?

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
    []
  end
end
