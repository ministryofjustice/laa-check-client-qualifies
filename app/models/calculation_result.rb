class CalculationResult
  CFE_MAX_VALUE = 999_999_999_999

  include ActionView::Helpers::NumberHelper
  def initialize(api_response)
    @api_response = api_response
  end

  def decision
    api_response.dig(:result_summary, :overall_result, :result) || "ineligible"
  end

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
    monetise(api_response.dig(:result_summary, :gross_income, :proceeding_types)&.map { |pt| pt.fetch(:upper_threshold) }&.min)
  end

  def total_disposable_income
    monetise(api_response.dig(:result_summary, :disposable_income, :total_disposable_income))
  end

  def disposable_income_limit
    monetise(api_response.dig(:result_summary, :disposable_income, :proceeding_types)&.map { |pt| pt.fetch(:upper_threshold) }&.min)
  end

  def total_capital
    monetise(api_response.dig(:result_summary, :capital, :total_capital))
  end

  def total_capital_limit
    monetise(api_response.dig(:result_summary, :capital, :proceeding_types)&.map { |pt| pt.fetch(:upper_threshold) }&.min)
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

  def client_capital_rows
    data = {
      property: capital_items(:properties)&.dig(:main_home, :net_equity),
      vehicles: capital_items(:vehicles)&.sum(0) { |z| z.fetch(:assessed_value) },
      # unfortunately CFE returns capital items as strings rather than numbers for some reason.
      second_property: capital_items(:properties)&.fetch(:additional_properties)&.sum(0) { |p| p.fetch(:net_equity).to_i },
      savings: capital_items(:liquid)&.sum(0) { |z| z.fetch(:value).to_i },
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
