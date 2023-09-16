module PropertySummarisable
  # MAIN HOME
  # Value
  def main_home_value
    from_cfe_payload("assessment.capital.capital_items.properties.main_home.value") || 0 unless asylum_support?
  end

  def smod_main_home_value
    if any_smod_assets?
      house_in_dispute ? main_home_value : 0
    end
  end

  def non_smod_main_home_value
    unless asylum_support?
      house_in_dispute ? 0 : main_home_value || 0
    end
  end

  # Outstanding mortgage
  def main_home_outstanding_mortgage
    from_cfe_payload("assessment.capital.capital_items.properties.main_home.outstanding_mortgage") || 0 unless asylum_support?
  end

  def non_smod_main_home_outstanding_mortgage
    unless asylum_support?
      house_in_dispute ? 0 : main_home_outstanding_mortgage || 0
    end
  end

  def smod_main_home_outstanding_mortgage
    if any_smod_assets?
      house_in_dispute ? main_home_outstanding_mortgage : 0
    end
  end

  # Percentage owned
  def main_home_percentage_owned
    percentage_owned || 0 unless asylum_support? || !client_income_relevant?
  end

  def smod_main_home_percentage_owned
    if any_smod_assets?
      house_in_dispute ? main_home_percentage_owned : 0
    end
  end

  def non_smod_main_home_percentage_owned
    unless asylum_support?
      house_in_dispute ? 0 : main_home_percentage_owned || 0
    end
  end

  # Net value
  def main_home_net_value
    from_cfe_payload("assessment.capital.capital_items.properties.main_home.net_value") || 0 unless asylum_support?
  end

  def non_smod_main_home_net_value
    unless asylum_support?
      house_in_dispute ? 0 : main_home_net_value || 0
    end
  end

  def smod_main_home_net_value
    if any_smod_assets?
      house_in_dispute ? main_home_net_value : 0
    end
  end

  # Net equity
  def main_home_net_equity
    from_cfe_payload("assessment.capital.capital_items.properties.main_home.net_equity") || 0 unless asylum_support?
  end

  def smod_main_home_net_equity
    if any_smod_assets?
      house_in_dispute ? main_home_net_equity : 0
    end
  end

  def non_smod_main_home_net_equity
    unless asylum_support?
      house_in_dispute ? 0 : main_home_net_equity || 0
    end
  end

  # Assessed equity
  def main_home_assessed_equity
    from_cfe_payload("assessment.capital.capital_items.properties.main_home.assessed_equity") || 0 unless asylum_support?
  end

  def smod_main_home_assessed_equity
    if any_smod_assets?
      house_in_dispute ? main_home_assessed_equity : 0
    end
  end

  def non_smod_main_home_assessed_equity
    house_in_dispute ? 0 : main_home_assessed_equity || 0
  end

  # ADDITIONAL PROPERTIES
  # Value
  def additional_properties_value
    additional_properties_sum("value") || 0
  end

  def non_smod_additional_properties_value
    additional_properties_sum("value", smod: false) || 0
  end

  def smod_additional_properties_value
    additional_properties_sum("value", smod: true)
  end

  # Outstanding mortgage
  def additional_properties_mortgage
    additional_properties_sum("outstanding_mortgage") || 0
  end

  def non_smod_additional_properties_mortgage
    additional_properties_sum("outstaging_mortgage", smod: false) || 0
  end

  def smod_additional_properties_outstanding_mortgage
    additional_properties_sum("outstanding_mortgage", smod: true)
  end

  # Percentage owned
  def smod_additional_properties_percentage_owned
    if any_smod_assets? && !smod_additional_properties_value.nil?
      additional_properties_percentage_owned(properties: combined_additional_properties.select { _1["subject_matter_of_dispute"] })
    end
  end

  def non_smod_additional_properties_percentage_owned
    additional_properties_percentage_owned(properties: combined_additional_properties.reject { _1["subject_matter_of_dispute"] }) || 0
  end

  def additional_properties_percentage_owned(properties: combined_additional_properties)
    # If there are 2 additional properties and a different percentage of each is owned,
    # we can't necessarily give a sensible figure here, so mark it as such
    return unless client_capital_relevant?

    percentages = properties.map { _1["percentage_owned"] }
    return if percentages.uniq.length > 1

    percentages.first || 0
  end

  # Net value
  def additional_properties_net_value
    additional_properties_sum("net_value") || 0
  end

  def non_smod_additional_properties_net_value
    additional_properties_sum("net_value", smod: false) || 0
  end

  def smod_additional_properties_net_value
    additional_properties_sum("net_value", smod: true)
  end

  # Net equity
  def additional_properties_net_equity
    additional_properties_sum("net_equity") || 0
  end

  def non_smod_additional_properties_net_equity
    additional_properties_sum("net_equity", smod: false) || 0
  end

  def smod_additional_properties_net_equity
    additional_properties_sum("net_equity", smod: true)
  end

  # Assessed equity
  def additional_properties_assessed_equity
    additional_properties_sum("assessed_equity") || 0
  end

  def smod_additional_properties_assessed_equity
    additional_properties_sum("assessed_equity", smod: true)
  end

  def non_smod_additional_properties_assessed_equity
    additional_properties_sum("assessed_equity", smod: false) || 0
  end

private

  def additional_properties_sum(attribute, smod: nil)
    return unless client_capital_relevant?

    group = case smod
            when nil
              combined_additional_properties
            when true
              combined_additional_properties.select { _1["subject_matter_of_dispute"] }
            else
              # We need to capture properties where `subject_matter_of_dispute` is either false OR nil
              combined_additional_properties.reject { _1["subject_matter_of_dispute"] }
            end
    return if group.none?

    result = group.sum { _1[attribute] || 0 }
    result || 0
  end

  def combined_additional_properties
    [
      session_data.dig("api_response", "assessment", "capital", "capital_items", "properties", "additional_properties"),
      session_data.dig("api_response", "assessment", "partner_capital", "capital_items", "properties", "additional_properties"),
    ].flatten.compact
  end
end
