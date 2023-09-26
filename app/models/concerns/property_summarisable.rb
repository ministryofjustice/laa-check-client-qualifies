module PropertySummarisable
  # MAIN HOME
  # Value
  def main_home_value
    from_cfe_payload("assessment.capital.capital_items.properties.main_home.value")
  end

  def smod_main_home_value
    main_home_value if house_in_dispute
  end

  def non_smod_main_home_value
    main_home_value unless house_in_dispute
  end

  # Outstanding mortgage
  def main_home_outstanding_mortgage
    from_cfe_payload("assessment.capital.capital_items.properties.main_home.outstanding_mortgage")
  end

  def non_smod_main_home_outstanding_mortgage
    main_home_outstanding_mortgage unless house_in_dispute
  end

  def smod_main_home_outstanding_mortgage
    main_home_outstanding_mortgage if house_in_dispute
  end

  # Percentage owned
  def main_home_percentage_owned
    percentage_owned
  end

  def smod_main_home_percentage_owned
    main_home_percentage_owned if house_in_dispute
  end

  def non_smod_main_home_percentage_owned
    main_home_percentage_owned unless house_in_dispute
  end

  # Net value
  def main_home_net_value
    from_cfe_payload("assessment.capital.capital_items.properties.main_home.net_value")
  end

  def non_smod_main_home_net_value
    main_home_net_value unless house_in_dispute
  end

  def smod_main_home_net_value
    main_home_net_value if house_in_dispute
  end

  # Net equity
  def main_home_net_equity
    from_cfe_payload("assessment.capital.capital_items.properties.main_home.net_equity")
  end

  def smod_main_home_net_equity
    main_home_net_equity if house_in_dispute
  end

  def non_smod_main_home_net_equity
    main_home_net_equity unless house_in_dispute
  end

  # Assessed equity
  def main_home_assessed_equity
    from_cfe_payload("assessment.capital.capital_items.properties.main_home.assessed_equity")
  end

  def smod_main_home_assessed_equity
    main_home_assessed_equity if house_in_dispute
  end

  def non_smod_main_home_assessed_equity
    main_home_assessed_equity unless house_in_dispute
  end

  # ADDITIONAL PROPERTIES
  # Value
  def additional_properties_value
    additional_properties_sum("value")
  end

  def non_smod_additional_properties_value
    additional_properties_sum("value", smod: false)
  end

  def smod_additional_properties_value
    additional_properties_sum("value", smod: true)
  end

  # Outstanding mortgage
  def additional_properties_mortgage
    additional_properties_sum("outstanding_mortgage")
  end

  def non_smod_additional_properties_mortgage
    additional_properties_sum("outstaging_mortgage", smod: false)
  end

  def smod_additional_properties_outstanding_mortgage
    additional_properties_sum("outstanding_mortgage", smod: true)
  end

  # Percentage owned
  def smod_additional_properties_percentage_owned
    additional_properties_percentage_owned(properties: combined_additional_properties.select { _1["subject_matter_of_dispute"] })
  end

  def non_smod_additional_properties_percentage_owned
    additional_properties_percentage_owned(properties: combined_additional_properties.reject { _1["subject_matter_of_dispute"] })
  end

  def additional_properties_percentage_owned(properties: combined_additional_properties)
    # If there are 2 additional properties and a different percentage of each is owned,
    # we can't necessarily give a sensible figure here, so mark it as such
    percentages = properties.map { _1["percentage_owned"] }
    return "" if percentages.uniq.length > 1

    percentages.first
  end

  # Net value
  def additional_properties_net_value
    additional_properties_sum("net_value")
  end

  def non_smod_additional_properties_net_value
    additional_properties_sum("net_value", smod: false)
  end

  def smod_additional_properties_net_value
    additional_properties_sum("net_value", smod: true)
  end

  # Net equity
  def additional_properties_net_equity
    additional_properties_sum("net_equity")
  end

  def non_smod_additional_properties_net_equity
    additional_properties_sum("net_equity", smod: false)
  end

  def smod_additional_properties_net_equity
    additional_properties_sum("net_equity", smod: true)
  end

  # Assessed equity
  def additional_properties_assessed_equity
    additional_properties_sum("assessed_equity")
  end

  def smod_additional_properties_assessed_equity
    additional_properties_sum("assessed_equity", smod: true)
  end

  def non_smod_additional_properties_assessed_equity
    additional_properties_sum("assessed_equity", smod: false)
  end

private

  def additional_properties_sum(attribute, smod: nil)
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

    group.sum { _1[attribute] || 0 }
  end

  def combined_additional_properties
    [
      session_data.dig("api_response", "assessment", "capital", "capital_items", "properties", "additional_properties"),
      session_data.dig("api_response", "assessment", "partner_capital", "capital_items", "properties", "additional_properties"),
    ].flatten.compact
  end
end
