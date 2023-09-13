module OutgoingsSummarisable
  def client_mortgage
    client_income_relevant? && property_owned_with_mortgage? ? net_housing_costs : 0
  end

  def client_rent
    client_income_relevant? && !owns_property? ? net_housing_costs : 0
  end

  def partner_mortgage
    if partner_income_relevant? && property_owned_with_mortgage?
      net_housing_costs("partner_").nil? ? 0 : net_housing_costs("partner_")
    elsif partner_income_relevant?
      0
    end
  end

  def partner_rent
    if partner_income_relevant? && !owns_property?
      net_housing_costs("partner_").nil? ? 0 : net_housing_costs("partner_")
    elsif partner_income_relevant?
      0
    end
  end

  def partner_allowance
    from_cfe_payload("result_summary.disposable_income.partner_allowance") if client_income_relevant? && partner
  end

  def dependants_allowance_under_16
    # We should show this field if there are any child dependants without income, as we assume all child dependants without income are over 16
    if client_income_relevant? && child_dependants && not_all_child_dependants_are_over_16
      from_cfe_payload("result_summary.disposable_income.dependant_allowance_under_16")
    elsif client_income_relevant?
      0
    end
  end

  def not_all_child_dependants_are_over_16
    # We don't directly associate dependant incomes with dependants. We assume that all dependant incomes belong to adults
    # unless there are more dependant incomes than there are adult dependants. So if the total number of dependants exceeds the
    # total number of incomes, we know that if there are any child dependants, at least one of them has no income and is therefore under 16.
    child_dependants_count + (adult_dependants ? adult_dependants_count : 0) > (dependant_incomes&.count || 0)
  end

  def dependants_allowance_over_16
    # We should show this field if there are any child dependants without income, as we assume all child dependants without income are over 16
    if client_income_relevant? && (adult_dependants || dependant_incomes.present?)
      from_cfe_payload("result_summary.disposable_income.dependant_allowance_over_16")
    elsif client_income_relevant?
      0
    end
  end

  def client_tax_and_national_insurance
    if client_income_relevant? && employed?
      tax_and_national_insurance
    elsif client_income_relevant?
      0
    end
  end

  def partner_tax_and_national_insurance
    if partner_income_relevant? && partner_employed?
      tax_and_national_insurance("partner_")
    elsif partner_income_relevant?
      0
    end
  end

  def client_employment_deduction
    if client_income_relevant? && employed?
      employment_deduction
    elsif client_income_relevant?
      0
    end
  end

  def partner_employment_deduction
    if partner_income_relevant? && partner_employed?
      employment_deduction("partner_")
    elsif partner_income_relevant?
      0
    end
  end

  def client_maintenance_allowance
    from_cfe_payload("result_summary.disposable_income.maintenance_allowance") if client_income_relevant?
  end

  def partner_maintenance_allowance
    from_cfe_payload("result_summary.partner_disposable_income.maintenance_allowance") if partner_income_relevant?
  end

  def combined_childcare_costs
    if client_income_relevant? && eligible_for_childcare_costs?
      (session_data.dig("api_response", "assessment", "disposable_income", "childcare_allowance") || 0) +
        (session_data.dig("api_response", "assessment", "partner_disposable_income", "childcare_allowance") || 0)
    elsif client_income_relevant?
      0
    end
  end

  def client_legal_aid_contribution
    from_cfe_payload("assessment.disposable_income.monthly_equivalents.all_sources.legal_aid") if client_income_relevant?
  end

  def partner_legal_aid_contribution
    from_cfe_payload("assessment.partner_disposable_income.monthly_equivalents.all_sources.legal_aid") if partner_income_relevant?
  end

  def client_total_allowances
    from_cfe_payload("result_summary.disposable_income.total_outgoings_and_allowances") if client_income_relevant?
  end

  def partner_total_allowances
    from_cfe_payload("result_summary.partner_disposable_income.total_outgoings_and_allowances") if partner_income_relevant?
  end

private

  def net_housing_costs(summary_section_prefix = "")
    session_data.dig("api_response", "result_summary", "#{summary_section_prefix}disposable_income", "net_housing_costs")
  end

  def tax_and_national_insurance(summary_section_prefix = "")
    tax = session_data.dig("api_response", "result_summary", "#{summary_section_prefix}disposable_income", "employment_income", "tax") || 0
    national_insurance = session_data.dig("api_response", "result_summary", "#{summary_section_prefix}disposable_income", "employment_income", "national_insurance") || 0
    # CFE returns these figures as negative numbers, but we want positive numbers on the form
    -1 * (tax + national_insurance)
  end

  def employment_deduction(summary_section_prefix = "")
    deduction = session_data.dig("api_response", "result_summary", "#{summary_section_prefix}disposable_income", "employment_income", "fixed_employment_deduction") || 0
    # CFE returns this figure as a negative number, but we want a positive number on the form
    -1 * deduction
  end
end
