module AssetSummarisable
  # Savings
  def savings
    bank_accounts&.sum { _1.amount.to_d }
  end

  def smod_savings
    bank_accounts.select(&:account_in_dispute).sum { _1.amount.to_d } if bank_accounts&.select(&:account_in_dispute)&.any?
  end

  def non_smod_client_savings
    bank_accounts.reject(&:account_in_dispute).sum { _1.amount.to_d } if bank_accounts&.reject(&:account_in_dispute)&.any?
  end

  def partner_savings
    partner_bank_accounts&.sum { _1.amount.to_d }
  end

  # Investments
  def smod_investments
    investments if investments_in_dispute
  end

  def non_smod_client_investments
    investments unless investments_in_dispute
  end

  # Valuables
  def smod_valuables
    valuables if valuables_in_dispute
  end

  def non_smod_client_valuables
    valuables unless valuables_in_dispute
  end

  # Totals
  def smod_total_capital
    from_cfe_payload("result_summary.capital.combined_disputed_capital") if smod_assets?
  end

  def combined_non_disputed_capital
    from_cfe_payload("result_summary.capital.combined_non_disputed_capital") if client_capital_relevant?
  end

  def combined_assessed_capital
    from_cfe_payload("result_summary.capital.combined_assessed_capital") if client_capital_relevant?
  end
end
