module IncomeSummarisable
  def client_non_employment_income
    non_employment_income || 0
  end

  def partner_non_employment_income
    non_employment_income("partner_") if partner_income_relevant?
  end

  def client_total_income
    total_income || 0
  end

  def partner_total_income
    total_income("partner_") if partner_income_relevant?
  end

  def total_combined_income
    from_cfe_payload("result_summary.gross_income.combined_total_gross_income") || 0
  end

  def client_gross_income
    employment_income || 0
  end

  def partner_gross_income
    employment_income("partner_") if partner_income_relevant?
  end

  def client_disposable_income
    from_cfe_payload("result_summary.disposable_income.total_disposable_income") || 0
  end

  def partner_disposable_income
    from_cfe_payload("result_summary.partner_disposable_income.total_disposable_income") if partner_income_relevant?
  end

  def combined_disposable_income
    from_cfe_payload("result_summary.disposable_income.combined_total_disposable_income") || 0
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
