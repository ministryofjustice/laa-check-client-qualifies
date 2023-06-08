# This model presents the session data for a check in a way that enables ControlledWorkDocumentValueMappingService
# to access all the values specified by any given "mapping". These mappings either specify a direct attribute
# or a method in this model.

# In the former case, the attribute is either one that the `Check` superclass makes available (i.e. it's
# an attribute that's available in the session, with Check's extra logic to make sure that it's
# an attribute associated with a screen that is relevant to the check), or its an attribute that's defined
# explicitly as a method below

# In the latter case, the "path" specifies the location in the "api_response" hash that we expect to find
# in the session, which contains all the information CFE returned when we asked it to perform an
# eligibility calculation for this check
class ControlledWorkDocumentContent < Check
  def from_cfe_payload(path)
    path_parts = path.split(".").map { _1.to_i.to_s == _1 ? _1.to_i : _1 }
    session_data.dig("api_response", *path_parts)
  end

  def asylum_support?
    asylum_support || false
  end

  def aggregate_partner?
    partner unless asylum_support?
  end

  def not_passporting?
    !passporting unless asylum_support?
  end

  def no_partner?
    !partner unless asylum_support?
  end

  def no_asylum_support?
    !asylum_support
  end

  def smod_assets?
    return if asylum_support?

    any_smod_assets?
  end

  def no_smod_assets?
    !smod_assets?
  end

  def additional_property_in_dispute?
    additional_house_in_dispute || in_dispute.include?("property") unless asylum_support?
  end

  def savings_in_dispute?
    in_dispute.include? "savings" unless asylum_support?
  end

  def investments_in_dispute?
    in_dispute.include? "investments" unless asylum_support?
  end

  def valuables_in_dispute?
    in_dispute.include? "valuables" unless asylum_support?
  end

  def client_capital_relevant?
    Steps::Helper.valid_step?(session_data, :assets)
  end

  def client_income_relevant?
    Steps::Helper.valid_step?(session_data, :other_income)
  end

  def partner_income_relevant?
    Steps::Helper.valid_step?(session_data, :partner_other_income)
  end

  def smod_main_home_value
    from_cfe_payload("assessment.capital.capital_items.properties.main_home.value") if house_in_dispute
  end

  def smod_main_home_outstanding_mortgage
    from_cfe_payload("assessment.capital.capital_items.properties.main_home.outstanding_mortgage") if house_in_dispute
  end

  def smod_additional_properties_value
    from_cfe_payload("assessment.capital.capital_items.properties.additional_properties.0.value") if additional_property_in_dispute?
  end

  def smod_additional_properties_outstanding_mortgage
    from_cfe_payload("assessment.capital.capital_items.properties.additional_properties.0.outstanding_mortgage") if additional_property_in_dispute?
  end

  def smod_main_home_percentage_owned
    return unless house_in_dispute

    if joint_ownership
      percentage_owned + joint_percentage_owned
    else
      percentage_owned || partner_percentage_owned
    end
  end

  def smod_main_home_net_value
    from_cfe_payload("assessment.capital.capital_items.properties.main_home.net_value") if house_in_dispute
  end

  def smod_additional_properties_net_value
    from_cfe_payload("assessment.capital.capital_items.properties.additional_properties.0.net_value") if additional_property_in_dispute?
  end

  def smod_main_home_net_equity
    from_cfe_payload("assessment.capital.capital_items.properties.main_home.net_equity") if house_in_dispute
  end

  def smod_additional_properties_net_equity
    from_cfe_payload("assessment.capital.capital_items.properties.additional_properties.0.net_equity") if additional_property_in_dispute?
  end

  def smod_main_home_assessed_equity
    from_cfe_payload("assessment.capital.capital_items.properties.main_home.assessed_equity") if house_in_dispute
  end

  def smod_additional_properties_assessed_equity
    from_cfe_payload("assessment.capital.capital_items.properties.additional_properties.0.assessed_equity") if additional_property_in_dispute?
  end

  def smod_additional_properties_percentage_owned
    from_cfe_payload("assessment.capital.capital_items.properties.additional_properties.0.percentage_owned") if additional_property_in_dispute?
  end

  def smod_savings
    savings if savings_in_dispute?
  end

  def smod_investments
    investments if investments_in_dispute?
  end

  def smod_valuables
    valuables if valuables_in_dispute?
  end

  def smod_total_capital
    from_cfe_payload("result_summary.capital.combined_disputed_capital") if smod_assets?
  end

  def non_smod_main_home_value
    main_home_value unless house_in_dispute
  end

  def main_home_value
    from_cfe_payload("assessment.capital.capital_items.properties.main_home.value") if client_capital_relevant?
  end

  def non_smod_main_home_net_value
    main_home_net_value unless house_in_dispute
  end

  def main_home_net_value
    from_cfe_payload("assessment.capital.capital_items.properties.main_home.net_value") if client_capital_relevant?
  end

  def non_smod_main_home_outstanding_mortgage
    main_home_outstanding_mortgage unless house_in_dispute
  end

  def main_home_outstanding_mortgage
    from_cfe_payload("assessment.capital.capital_items.properties.main_home.outstanding_mortgage") if client_capital_relevant?
  end

  def non_smod_main_home_percentage_owned
    main_home_percentage_owned unless house_in_dispute
  end

  def main_home_percentage_owned
    if joint_ownership
      percentage_owned + joint_percentage_owned
    else
      percentage_owned || partner_percentage_owned
    end
  end

  def non_smod_main_home_net_equity
    main_home_net_equity unless house_in_dispute
  end

  def main_home_net_equity
    from_cfe_payload("assessment.capital.capital_items.properties.main_home.net_equity") if client_capital_relevant?
  end

  def non_smod_main_home_assessed_equity
    main_home_assessed_equity unless house_in_dispute
  end

  def main_home_assessed_equity
    from_cfe_payload("assessment.capital.capital_items.properties.main_home.assessed_equity") if client_capital_relevant?
  end

  def non_smod_additional_properties_value
    additional_properties_value unless additional_property_in_dispute?
  end

  def additional_properties_value
    additional_properties_sum("value") if client_capital_relevant?
  end

  def non_smod_additional_properties_mortgage
    additional_properties_mortgage unless additional_property_in_dispute?
  end

  def additional_properties_mortgage
    additional_properties_sum("outstanding_mortgage") if client_capital_relevant?
  end

  def non_smod_additional_properties_percentage_owned
    additional_properties_percentage_owned unless additional_property_in_dispute?
  end

  def additional_properties_percentage_owned
    # If there are 2 additional properties and a different percentage of each is owned,
    # we can't necessarily give a sensible figure here, so mark it as such
    return unless client_capital_relevant?

    percentages = additional_properties.map { _1["percentage_owned"] }
    return if percentages.uniq.length > 1

    percentages.first
  end

  def non_smod_additional_properties_net_value
    additional_properties_net_value unless additional_property_in_dispute?
  end

  def additional_properties_net_value
    additional_properties_sum("net_value") if client_capital_relevant?
  end

  def non_smod_additional_properties_net_equity
    additional_properties_net_equity unless additional_property_in_dispute?
  end

  def additional_properties_net_equity
    additional_properties_sum("net_equity") if client_capital_relevant?
  end

  def non_smod_additional_properties_assessed_equity
    additional_properties_assessed_equity unless additional_property_in_dispute?
  end

  def additional_properties_assessed_equity
    additional_properties_sum("assessed_equity") if client_capital_relevant?
  end

  def additional_properties_sum(attribute)
    additional_properties.sum { _1[attribute] }
  end

  def additional_properties
    [
      session_data.dig("api_response", "assessment", "capital", "capital_items", "properties", "additional_properties"),
      session_data.dig("api_response", "assessment", "partner_capital", "capital_items", "properties", "additional_properties"),
    ].flatten.compact
  end

  def non_smod_client_savings
    savings unless savings_in_dispute?
  end

  def non_smod_client_investments
    investments unless investments_in_dispute?
  end

  def non_smod_client_valuables
    valuables unless valuables_in_dispute?
  end

  def combined_non_disputed_capital
    from_cfe_payload("result_summary.capital.combined_non_disputed_capital") if client_capital_relevant?
  end

  def combined_assessed_capital
    from_cfe_payload("result_summary.capital.combined_assessed_capital") if client_capital_relevant?
  end

  def client_non_employment_income
    non_employment_income if client_income_relevant?
  end

  def partner_non_employment_income
    non_employment_income("partner_") if partner_income_relevant?
  end

  def client_total_income
    from_cfe_payload("result_summary.gross_income.total_gross_income") if client_income_relevant?
  end

  def partner_total_income
    from_cfe_payload("result_summary.partner_gross_income.total_gross_income") if partner_income_relevant?
  end

  def total_combined_income
    from_cfe_payload("result_summary.gross_income.combined_total_gross_income") if client_income_relevant?
  end

  def client_mortgage
    (main_home_owned? ? net_housing_costs : 0) if client_income_relevant?
  end

  def client_rent
    (main_home_owned? ? 0 : net_housing_costs) if client_income_relevant?
  end

  def partner_mortgage
    (main_home_owned? ? net_housing_costs("partner_") : 0) if partner_income_relevant?
  end

  def partner_rent
    (main_home_owned? ? 0 : net_housing_costs("partner_")) if partner_income_relevant?
  end

  def client_gross_income
    from_cfe_payload("result_summary.disposable_income.employment_income.gross_income") if client_income_relevant?
  end

  def partner_gross_income
    from_cfe_payload("result_summary.partner_disposable_income.employment_income.gross_income") if partner_income_relevant?
  end

  def partner_allowance
    from_cfe_payload("result_summary.disposable_income.partner_allowance") if client_income_relevant?
  end

  def dependants_allowance_under_16
    from_cfe_payload("result_summary.disposable_income.dependant_allowance_under_16") if client_income_relevant?
  end

  def dependants_allowance_over_16
    from_cfe_payload("result_summary.disposable_income.dependant_allowance_over_16") if client_income_relevant?
  end

  def client_tax_and_national_insurance
    tax_and_national_insurance if client_income_relevant?
  end

  def partner_tax_and_national_insurance
    tax_and_national_insurance "partner_" if partner_income_relevant?
  end

  def client_employment_deduction
    employment_deduction if client_income_relevant?
  end

  def client_maintenance_allowance
    from_cfe_payload("result_summary.disposable_income.maintenance_allowance") if client_income_relevant?
  end

  def partner_maintenance_allowance
    from_cfe_payload("result_summary.partner_disposable_income.maintenance_allowance") if partner_income_relevant?
  end

  def partner_employment_deduction
    employment_deduction "partner_" if partner_income_relevant?
  end

  def combined_childcare_costs
    return unless client_income_relevant?

    (session_data.dig("api_response", "assessment", "disposable_income", "childcare_allowance") || 0) +
      (session_data.dig("api_response", "assessment", "partner_disposable_income", "childcare_allowance") || 0)
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

  def client_disposable_income
    from_cfe_payload("result_summary.disposable_income.total_disposable_income") if client_income_relevant?
  end

  def partner_disposable_income
    from_cfe_payload("result_summary.partner_disposable_income.total_disposable_income") if partner_income_relevant?
  end

  def combined_disposable_income
    from_cfe_payload("result_summary.disposable_income.combined_total_disposable_income") if client_income_relevant?
  end

  def non_employment_income(summary_section_prefix = "")
    total_income = session_data.dig("api_response", "result_summary", "#{summary_section_prefix}gross_income", "total_gross_income") || 0
    employment_income = session_data.dig("api_response", "result_summary", "#{summary_section_prefix}disposable_income", "employment_income", "gross_income") || 0
    total_income - employment_income
  end

  def net_housing_costs(summary_section_prefix = "")
    session_data.dig("api_response", "result_summary", "#{summary_section_prefix}disposable_income", "net_housing_costs")
  end

  def main_home_owned?
    percentage_owned.present? || partner_percentage_owned.present?
  end

  def tax_and_national_insurance(summary_section_prefix = "")
    tax = session_data.dig("api_response", "result_summary", "#{summary_section_prefix}disposable_income", "employment_income", "tax") || 0
    national_insurance = session_data.dig("api_response", "result_summary", "#{summary_section_prefix}disposable_income", "employment_income", "national_insurance") || 0
    -1 * (tax + national_insurance)
  end

  def employment_deduction(summary_section_prefix = "")
    deduction = session_data.dig("api_response", "result_summary", "#{summary_section_prefix}disposable_income", "employment_income", "fixed_employment_deduction") || 0
    -1 * deduction
  end
end
