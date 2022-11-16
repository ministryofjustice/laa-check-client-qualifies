class CalculationResult
  CFE_MAX_VALUE = 999_999_999_999

  include ActionView::Helpers::NumberHelper
  def initialize(api_response)
    @api_response = api_response
  end

  def eligible?
    decision == "eligible"
  end

  def decision
    api_response.dig(:result_summary, :overall_result, :result) || "ineligible"
  end

  # Note - this is probably technically incorrect as partially eligible could mean
  # eligible for 1 proceeding type and ineligible for the other. It can't happen here
  # as we only ever submit one proceeding type so partial eligibility can never occur
  def contribution_required?
    %w[contribution_required partially_eligible].include?(decision)
  end

  def capital_contribution
    monetise(api_response.dig(:result_summary, :overall_result, :capital_contribution))
  end

  def income_contribution
    monetise(api_response.dig(:result_summary, :overall_result, :income_contribution))
  end

  def gross_income
    monetise(api_response.dig(:result_summary, :gross_income, :total_gross_income))
  end

  def gross_outgoings
    monetise(api_response.dig(:result_summary, :disposable_income, :total_outgoings_and_allowances))
  end

  def gross_income_limit
    monetise(api_response.dig(:result_summary, :gross_income, :proceeding_types).map { |pt| pt.fetch(:upper_threshold) }.min)
  end

  def total_disposable_income
    monetise(api_response.dig(:result_summary, :disposable_income, :total_disposable_income))
  end

  def total_assessed_capital
    monetise(api_response.dig(:result_summary, :capital, :assessed_capital))
  end

  def disposable_income_limit
    monetise(api_response.dig(:result_summary, :disposable_income, :proceeding_types).map { |pt| pt.fetch(:upper_threshold) }.min)
  end

  def assessed_capital
    # If the pensioner_capital_disregard is applied, it is applied by CFE in full even when the disregard is
    # greater than the client's total capital value. This can lead to the CFE 'assessed capital' figure
    # being a negative number, which is unsuitable for display to the end user.
    # Therefore we must correct the CFE result to display a zero if it comes back negative.
    cfe_result = api_response.dig(:result_summary, :capital, :assessed_capital)
    monetise([cfe_result, 0].compact.max)
  end

  def total_capital
    monetise(api_response.dig(:result_summary, :capital, :total_capital))
  end

  def assessed_capital
    monetise(api_response.dig(:result_summary, :capital, :assessed_capital))
  end

  def client_income_rows
    data = {
      employment_income: api_response.dig(:result_summary, :disposable_income, :employment_income, :gross_income),
      benefits: api_response.dig(:assessment, :gross_income, :state_benefits, :monthly_equivalents, :all_sources),
      friends_and_family: extract_other_money(:friends_or_family),
      maintenance: extract_other_money(:maintenance_in),
      property_or_lodger: extract_other_money(:property_or_lodger),
      pension: extract_other_money(:pension),
      student_finance: api_response.dig(:assessment, :gross_income, :irregular_income, :monthly_equivalents, :student_loan),
      other: api_response.dig(:assessment, :gross_income, :irregular_income, :monthly_equivalents, :unspecified_source),
    }
    data.transform_values { |v| monetise(v) }
  end

  def client_outgoing_rows
    data = {
      housing_costs: disposable_income_value(:rent_or_mortgage),
      childcare_payments: disposable_income_value(:child_care),
      maintenance_out: disposable_income_value(:maintenance_out),
      legal_aid: disposable_income_value(:legal_aid),
      income_tax: employment_deduction(:tax),
      national_insurance: employment_deduction(:national_insurance),
      employment_expenses: employment_deduction(:fixed_employment_deduction),
      dependents_allowance: api_response.dig(:result_summary, :disposable_income,
                                             :dependant_allowance),
    }
    data.transform_values { |v| monetise(v) }
  end

  def main_home
    capital_items(:properties)[:main_home]
  end

  def main_home_value
    monetise(capital_items(:properties).dig(:main_home, :value))
  end

  def main_home_mortgage
    monetise(capital_items(:properties).dig(:main_home, :outstanding_mortgage))
  end

  def main_home_disregard
    monetise(capital_items(:properties).dig(:main_home, :main_home_equity_disregard))
  end

  def main_home_equity
    monetise(capital_items(:properties).dig(:main_home, :assessed_equity))
  end

  def additional_property
    capital_items(:properties)[:additional_properties]
  end

  def additional_property_value
    monetise(additional_property.first[:value])
  end

  def additional_property_mortgage
    monetise(additional_property.first[:outstanding_mortgage])
  end

  def additional_property_equity
    monetise(additional_property.first[:assessed_equity])
  end

  def vehicle_owned?
    capital_items(:vehicles).any?
  end

  def vehicle_value
    monetise(capital_items(:vehicles).sum(0) { |z| z.fetch(:value) })
  end

  def vehicle_outstanding_payments
    monetise(capital_items(:vehicles).sum(0) { |z| z.fetch(:loan_amount_outstanding) })
  end

  def vehicle_disregards
    value = capital_items(:vehicles).sum(0) { |z| z.fetch(:value) }
    pcp = capital_items(:vehicles).sum(0) { |z| z.fetch(:loan_amount_outstanding) }
    assessed_value = capital_items(:vehicles).sum(0) { |z| z.fetch(:assessed_value) }
    monetise(value - pcp - assessed_value)
  end

  def vehicle_assessed_value
    monetise(capital_items(:vehicles).sum(0) { |z| z.fetch(:assessed_value) })
  end

  def client_capital_rows
    data = {
      # unfortunately CFE returns capital items as strings rather than numbers for some reason.
      second_property: capital_items(:properties).fetch(:additional_properties).sum(0) { |p| p.fetch(:net_equity).to_i },
      savings: capital_items(:liquid).sum(0) { |z| z.fetch(:value).to_i },
    }
    data.transform_values { |value| monetise(value) }
  end

  def client_capital_subtotal_rows
    data = {
      total_capital: api_response.dig(:result_summary, :capital, :total_capital),
      total_capital_limit: api_response.dig(:result_summary, :capital, :proceeding_types)&.map { |pt| pt.fetch(:upper_threshold) }&.min,
      pensioner_capital_disregard: api_response.dig(:result_summary, :capital, :pensioner_capital_disregard),
      smod_disregard: api_response.dig(:result_summary, :capital, :subject_matter_of_dispute_disregard),
    }

    data.transform_values { |value| monetise(value) }
  end

private

  attr_reader :api_response

  def capital_items(key)
    api_response.dig(:assessment, :capital, :capital_items, key)
  end

  def employment_deduction(key)
    value = api_response.dig(:result_summary, :disposable_income, :employment_income, key)
    0 - value if value.present?
  end

  def disposable_income_value(key)
    api_response.dig(:assessment, :disposable_income,
                     :monthly_equivalents, :all_sources, key)
  end

  def extract_other_money(key)
    api_response.dig(:assessment, :gross_income, :other_income, :monthly_equivalents, :all_sources, key)
  end

  def monetise(number)
    return I18n.t("generic.not_applicable") if number.nil? || number == CFE_MAX_VALUE

    number_to_currency(number, unit: "£", separator: ".", delimiter: ",", precision: 2)
  end
end
