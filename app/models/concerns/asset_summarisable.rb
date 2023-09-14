module AssetSummarisable
  # Savings
  def savings
    bank_accounts&.sum { _1.amount.to_d }
  end

  def smod_savings
    bank_accounts&.select(&:account_in_dispute)&.any? ? bank_accounts.select(&:account_in_dispute).sum { _1.amount.to_d } : 0
  end

  def non_smod_client_savings
    bank_accounts&.reject(&:account_in_dispute)&.any? ? bank_accounts.reject(&:account_in_dispute).sum { _1.amount.to_d } : 0
  end

  def partner_savings
    partner_bank_accounts&.sum { _1.amount.to_d } || 0
  end

  # Investments
  def client_investments
    investments_in_dispute ? 0 : investments || 0
  end

  def partner_investments_value
    investments_in_dispute ? 0 : partner_investments || 0
  end
  def smod_investments
    investments_in_dispute ? investments : 0
  end

  def non_smod_client_investments
    investments_in_dispute ? 0 : investments || 0
  end

  # Valuables
  def client_valuables
    valuables_in_dispute ? 0 : valuables || 0
  end

  def partner_valuables_value
    valuables_in_dispute ? 0 : partner_valuables || 0
  end
  def smod_valuables
    valuables_in_dispute ? valuables : 0
  end

  def non_smod_client_valuables
    valuables_in_dispute ? 0 : valuables || 0
  end

  # Totals
  def smod_total_capital
    smod_assets? ? from_cfe_payload("result_summary.capital.combined_disputed_capital") : 0
  end

  def combined_non_disputed_capital
    from_cfe_payload("result_summary.capital.combined_non_disputed_capital") if client_capital_relevant?
  end

  def combined_assessed_capital
    from_cfe_payload("result_summary.capital.combined_assessed_capital") if client_capital_relevant?
  end
end
