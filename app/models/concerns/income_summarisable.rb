module IncomeSummarisable
  def client_non_employment_income
    non_employment_income
  end

  def partner_non_employment_income
    non_employment_income("partner_")
  end

  def client_total_income
    total_income
  end

  def partner_total_income
    total_income("partner_")
  end

  def total_combined_income
    from_cfe_payload("result_summary.gross_income.combined_total_gross_income")
  end

  def client_gross_income
    employment_income
  end

  def partner_gross_income
    employment_income("partner_")
  end

  def client_disposable_income
    from_cfe_payload("result_summary.disposable_income.total_disposable_income")
  end

  def partner_disposable_income
    from_cfe_payload("result_summary.partner_disposable_income.total_disposable_income")
  end

  def combined_disposable_income
    from_cfe_payload("result_summary.disposable_income.combined_total_disposable_income")
  end

  def client_benefits
    from_cfe_payload("assessment.gross_income.state_benefits.monthly_equivalents.all_sources")
  end

  def client_maintenance
    from_cfe_payload("assessment.gross_income.other_income.monthly_equivalents.all_sources.maintenance_in")
  end

  def client_pensions
    from_cfe_payload("assessment.gross_income.other_income.monthly_equivalents.all_sources.pension")
  end

  def client_student_finance
    from_cfe_payload("assessment.gross_income.irregular_income.monthly_equivalents.student_loan")
  end

  def client_friends_and_family
    from_cfe_payload("assessment.gross_income.other_income.monthly_equivalents.all_sources.friends_or_family")
  end

  def client_property_lodger_income
    from_cfe_payload("assessment.gross_income.other_income.monthly_equivalents.all_sources.property_or_lodger")
  end

  def client_other_income
    from_cfe_payload("assessment.gross_income.irregular_income.monthly_equivalents.unspecified_source")
  end

  def partner_benefits
    from_cfe_payload("assessment.partner_gross_income.state_benefits.monthly_equivalents.all_sources")
  end

  def partner_maintenance
    from_cfe_payload("assessment.partner_gross_income.other_income.monthly_equivalents.all_sources.maintenance_in")
  end

  def partner_pensions
    from_cfe_payload("assessment.partner_gross_income.other_income.monthly_equivalents.all_sources.pension")
  end

  def partner_student_finance
    from_cfe_payload("assessment.partner_gross_income.irregular_income.monthly_equivalents.student_loan")
  end

  def partner_friends_and_family
    from_cfe_payload("assessment.partner_gross_income.other_income.monthly_equivalents.all_sources.friends_or_family")
  end

  def partner_property_lodger_income
    from_cfe_payload("assessment.partner_gross_income.other_income.monthly_equivalents.all_sources.property_or_lodger")
  end

  def partner_other_income
    from_cfe_payload("assessment.partner_gross_income.irregular_income.monthly_equivalents.unspecified_source")
  end

private

  def employment_income(prefix = "")
    from_cfe_payload("result_summary.#{prefix}disposable_income.employment_income.gross_income")
  end

  def total_income(prefix = "")
    from_cfe_payload("result_summary.#{prefix}gross_income.total_gross_income")
  end

  def non_employment_income(summary_section_prefix = "")
    (total_income(summary_section_prefix) || 0) - (employment_income(summary_section_prefix) || 0)
  end
end
