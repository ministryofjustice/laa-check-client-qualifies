# This model presents the session data for a check in a way that enables ControlledWorkDocumentValueMappingService
# to access all the values specified by any given "mapping". These mappings either specify a direct attribute
# or a "CFE payload path".

# In the former case, the attribute is either one that the `Check` superclass makes available (i.e. it's
# an attribute that's available in the session, with Check's extra logic to make sure that it's
# an attribute associated with a screen that is relevant to the check), or its an attribute that's defined
# explicitly as a method below

# In the latter case, the "path" specifies the location in the "api_response" hash that we expect to find
# in the session, which contains all the information CFE returned when we asked it to perform an
# eligibility calculation for this check
class ControlledWorkDocumentContent < Check
  include ActionView::Helpers::NumberHelper

  def from_cfe_payload(path)
    path_parts = path.split(".").map { _1.to_i.to_s == _1 ? _1.to_i : _1 }
    value = session_data.dig("api_response", *path_parts)
    format(value)
  end

  def from_attribute(attribute)
    format(send(attribute))
  end

private

  def format(value)
    return unless value
    return value unless value.is_a?(Numeric)

    precision = value.round == value ? 0 : 2

    number_with_precision(value, precision:, delimiter: ",")
  end

  def smod_assets?
    house_in_dispute || vehicle_in_dispute || in_dispute.present?
  end

  def additional_property_in_dispute?
    in_dispute.include? "property"
  end

  def savings_in_dispute?
    in_dispute.include? "savings"
  end

  def investments_in_dispute?
    in_dispute.include? "investments"
  end

  def valuables_in_dispute?
    in_dispute.include? "valuables"
  end

  def main_home_percentage_owned
    if joint_ownership
      percentage_owned + joint_percentage_owned
    else
      percentage_owned || partner_percentage_owned
    end
  end

  def smod_total
    "TODO"
  end

  def non_smod_total
    "TODO"
  end

  def additional_non_smod_properties_value
    additional_non_smod_properties_sum "value"
  end

  def additional_non_smod_properties_mortgage
    additional_non_smod_properties_sum "outstanding_mortgage"
  end

  def additional_non_smod_properties_percentage_owned
    # If there are 2 additional properties and a different percentage of each is owned,
    # we can't necessarily give a sensible figure here, so leave it blank
    percentages = additional_non_smod_properties.map { _1["percentage_owned"] }
    return unless percentages.uniq.length == 1

    percentages.first
  end

  def additional_non_smod_properties_net_value
    additional_non_smod_properties_sum "net_value"
  end

  def additional_non_smod_properties_net_equity
    additional_non_smod_properties_sum "net_equity"
  end

  def additional_non_smod_properties_assessed_equity
    additional_non_smod_properties_sum "assessed_equity"
  end

  def client_capital_relevant?
    StepsHelper.valid_step?(session_data, :assets)
  end

  def client_income_relevant?
    StepsHelper.valid_step?(session_data, :other_income)
  end

  def partner_income_relevant?
    StepsHelper.valid_step?(session_data, :partner_other_income)
  end

  def not_passporting
    !passporting
  end

  def client_non_employment_income
    non_employment_income
  end

  def partner_non_employment_income
    non_employment_income("partner_")
  end

  def client_mortgage
    main_home_owned? ? net_housing_costs : 0
  end

  def client_rent
    main_home_owned? ? 0 : net_housing_costs
  end

  def partner_mortgage
    main_home_owned? ? net_housing_costs("partner_") : 0
  end

  def partner_rent
    main_home_owned? ? 0 : net_housing_costs("partner_")
  end

  def client_and_partner_under_16_dependant_allowance
    "TODO"
  end

  def client_and_partner_16_plus_dependant_allowance
    "TODO"
  end

  def client_tax_and_national_insurance
    tax_and_national_insurance
  end

  def partner_tax_and_national_insurance
    tax_and_national_insurance "partner_"
  end

  def client_employment_deduction
    employment_deduction
  end

  def partner_employment_deduction
    employment_deduction "partner_"
  end

  def combined_childcare_costs
    (session_data.dig("api_response", "assessment", "disposable_income", "childcare_allowance") || 0) +
      (session_data.dig("api_response", "assessment", "partner_disposable_income", "childcare_allowance") || 0)
  end

  def additional_non_smod_properties_sum(attribute)
    additional_non_smod_properties.sum { _1[attribute] }
  end

  def additional_non_smod_properties
    @additional_non_smod_properties ||= [
      (session_data.dig("api_response", "assessment", "capital", "capital_items", "properties", "additional_properties") unless additional_property_in_dispute?),
      session_data.dig("api_response", "assessment", "partner_capital", "capital_items", "properties", "additional_properties"),
    ].flatten.compact
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
