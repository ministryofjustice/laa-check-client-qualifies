module AssetSummarisable
  # Savings
  def savings
    bank_accounts&.sum { _1.amount.to_d }
  end

  def smod_savings
    return unless any_smod_assets?

    bank_accounts.select(&:account_in_dispute).any? ? bank_accounts.select(&:account_in_dispute).sum { _1.amount.to_d } : 0
  end

  def non_smod_client_savings
    bank_accounts&.reject(&:account_in_dispute)&.any? ? bank_accounts.reject(&:account_in_dispute).sum { _1.amount.to_d } : 0
  end

  def partner_savings
    partner_bank_accounts&.sum { _1.amount.to_d }
  end

  # Investments
  def smod_investments
    if any_smod_assets?
      investments_in_dispute ? investments : 0
    end
  end

  def non_smod_client_investments
    investments_in_dispute ? 0 : investments || 0
  end

  # Valuables
  def smod_valuables
    if any_smod_assets?
      valuables_in_dispute ? valuables : 0
    end
  end

  def non_smod_client_valuables
    valuables_in_dispute ? 0 : valuables || 0
  end

  # Totals
  def smod_total_capital
    from_cfe_payload("result_summary.capital.combined_disputed_capital") if smod_assets?
  end

  def combined_non_disputed_capital
    from_cfe_payload("result_summary.capital.combined_non_disputed_capital") || 0
  end

  def combined_assessed_capital
    from_cfe_payload("result_summary.capital.combined_assessed_capital") || 0
  end
end
