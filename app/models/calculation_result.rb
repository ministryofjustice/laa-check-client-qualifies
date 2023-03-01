class CalculationResult
  CFE_MAX_VALUE = 999_999_999_999
  VALID_OVERALL_RESULTS = %w[eligible contribution_required ineligible].freeze

  include ActionView::Helpers::NumberHelper

  attr_accessor :level_of_help

  def initialize(api_response)
    @api_response = api_response
  end

  def decision
    @decision ||= begin
      # In some circumstances CFE can return other results, such as 'partially_eligible'.
      # We believe that those circumstances can never be reached via CCQ.
      # However we want to safeguard against CFE doing something unexpected.
      result = api_response.dig(:result_summary, :overall_result, :result)
      raise "Unhandled CFE result: #{result}" unless VALID_OVERALL_RESULTS.include?(result)

      result
    end
  end

  def calculated?(section)
    api_response.dig(:result_summary, section, :proceeding_types).none? { _1[:result] == "pending" }
  end

  def capital_contribution
    monetise(api_response.dig(:result_summary, :overall_result, :capital_contribution))
  end

  def income_contribution
    monetise(api_response.dig(:result_summary, :overall_result, :income_contribution))
  end

  def gross_income
    monetise(api_response.dig(:result_summary, :gross_income, :combined_total_gross_income))
  end

  def gross_outgoings
    monetise(api_response.dig(:result_summary, :disposable_income, :combined_total_outgoings_and_allowances))
  end

  def gross_income_upper_threshold
    monetise(api_response.dig(:result_summary, :gross_income, :proceeding_types).map { |pt| pt.fetch(:upper_threshold) }.min)
  end

  def total_disposable_income
    monetise(api_response.dig(:result_summary, :disposable_income, :combined_total_disposable_income))
  end

  def total_assessed_capital
    # # If the pensioner_capital_disregard is applied, it is applied by CFE in full even when the disregard is
    # # greater than the client's total capital value. This can lead to the CFE 'assessed capital' figure
    # # being a negative number, which is unsuitable for display to the end user.
    # # Therefore we must correct the CFE result to display a zero if it comes back negative.
    monetise([api_response.dig(:result_summary, :capital, :combined_assessed_capital), 0].compact.max)
  end

  def disposable_income_upper_threshold
    monetise(api_response.dig(:result_summary, :disposable_income, :proceeding_types).map { |pt| pt.fetch(:upper_threshold) }.min)
  end

  def capital_upper_threshold
    monetise(api_response.dig(:result_summary, :capital, :proceeding_types).map { |pt| pt.fetch(:upper_threshold) }.min)
  end

  def client_assessed_capital
    monetise(api_response.dig(:result_summary, :capital, :total_capital_with_smod))
  end

  def partner_assessed_capital
    # If the pensioner_capital_disregard is applied, it is applied by CFE in full even when the disregard is
    # greater than the client's total capital value. This can lead to the CFE 'assessed capital' figure
    # being a negative number, which is unsuitable for display to the end user.
    # Therefore we must correct the CFE result to display a zero if it comes back negative.
    cfe_result = api_response.dig(:result_summary, :partner_capital, :assessed_capital)
    monetise([cfe_result, 0].compact.max)
  end

  def client_income_rows
    income_rows(prefix: "")
  end

  def has_partner?
    @has_partner ||= api_response.dig(:assessment, :partner_capital).present?
  end

  def pensioner_disregard_applied?
    api_response.dig(:result_summary, :capital, :pensioner_capital_disregard).positive?
  end

  def partner_income_rows
    income_rows(prefix: "partner_")
  end

  def client_outgoing_rows
    outgoing_rows(prefix: "")
  end

  def partner_outgoing_rows
    outgoing_rows(prefix: "partner_")
  end

  def client_owns_main_home?
    capital_items(:properties).dig(:main_home, :value)&.positive?
  end

  def client_main_home_rows
    main_home_rows(prefix: "")
  end

  def client_owns_additional_property?
    capital_items(:properties)[:additional_properties].present?
  end

  def partner_owns_additional_property?
    partner_capital_items(:properties)&.dig(:additional_properties).present?
  end

  def client_additional_property_rows
    additional_property_rows(prefix: "")
  end

  def partner_additional_property_rows
    additional_property_rows(prefix: "partner_")
  end

  def vehicle_owned?
    capital_items(:vehicles).any?
  end

  def partner_vehicle_owned?
    partner_capital_items(:vehicles)&.any?
  end

  def client_vehicle_rows
    vehicle_rows(prefix: "")
  end

  def partner_vehicle_rows
    vehicle_rows(prefix: "partner_")
  end

  def client_capital_rows
    capital_rows(prefix: "")
  end

  def client_capital_subtotal_rows
    rows = {
      total_capital: monetise(api_response.dig(:result_summary, :capital, :total_capital)),
      pensioner_capital_disregard: monetise(-api_response.dig(:result_summary, :capital, :pensioner_capital_disregard)),
      smod_disregard: monetise(-api_response.dig(:result_summary, :capital, :subject_matter_of_dispute_disregard)),
    }

    if has_partner? && pensioner_disregard_applied?
      rows.except(:pensioner_capital_disregard)
    else
      rows
    end
  end

  def partner_capital_rows
    capital_rows(prefix: "partner_")
  end

  def pensioner_disregard_rows
    total_capital = api_response.dig(:result_summary, :capital, :total_capital) +
      api_response.dig(:result_summary, :partner_capital, :total_capital)
    disregarded = [total_capital, api_response.dig(:result_summary, :capital, :pensioner_capital_disregard)].min
    {
      total_capital: monetise(total_capital),
      pensioner_capital_disregard: monetise(-disregarded),
    }
  end

  def client_assessed_equity
    monetise(capital_items(:properties).dig(:main_home, :assessed_equity))
  end

  def client_additional_equity
    monetise(capital_items(:properties)[:additional_properties].first.fetch(:assessed_equity))
  end

  def partner_additional_equity
    monetise(partner_capital_items(:properties)[:additional_properties].first.fetch(:assessed_equity))
  end

  def client_vehicle_assessed_value
    monetise(capital_items(:vehicles).sum(0) { _1.fetch(:assessed_value) })
  end

  def partner_vehicle_assessed_value
    monetise(partner_capital_items(:vehicles).sum(0) { _1.fetch(:assessed_value) })
  end

private

  attr_reader :api_response

  def partner_capital_items(key)
    capital_items(key, "partner_")
  end

  def capital_items(key, prefix = "")
    api_response.dig(:assessment, :"#{prefix}capital", :capital_items, key)
  end

  def employment_deduction(key, prefix)
    value = api_response.dig(:result_summary, :"#{prefix}disposable_income", :employment_income, key)
    0 - value if value.present?
  end

  def disposable_income_value(key, prefix)
    api_response.dig(:assessment, :"#{prefix}disposable_income",
                     :monthly_equivalents, :all_sources, key)
  end

  def extract_other_income(key, prefix)
    api_response.dig(:assessment, :"#{prefix}gross_income", :other_income, :monthly_equivalents, :all_sources, key)
  end

  def monetise(number)
    return I18n.t("generic.not_applicable") if number.nil? || number == CFE_MAX_VALUE

    number_to_currency(number, unit: "£", separator: ".", delimiter: ",", precision: 2)
  end

  def income_rows(prefix:)
    data = {
      employment_income: api_response.dig(:result_summary, :"#{prefix}disposable_income", :employment_income, :gross_income),
      benefits: api_response.dig(:assessment, :"#{prefix}gross_income", :state_benefits, :monthly_equivalents, :all_sources),
      friends_and_family: extract_other_income(:friends_or_family, prefix),
      maintenance: extract_other_income(:maintenance_in, prefix),
      property_or_lodger: extract_other_income(:property_or_lodger, prefix),
      pension: extract_other_income(:pension, prefix),
      student_finance: api_response.dig(:assessment, :"#{prefix}gross_income", :irregular_income, :monthly_equivalents, :student_loan),
      other: api_response.dig(:assessment, :"#{prefix}gross_income", :irregular_income, :monthly_equivalents, :unspecified_source),
    }
    data.transform_values { |v| monetise(v) }
  end

  def outgoing_rows(prefix:)
    data = {
      housing_costs: api_response.dig(:result_summary, :"#{prefix}disposable_income", :net_housing_costs),
      childcare_payments: disposable_income_value(:child_care, prefix),
      maintenance_out: disposable_income_value(:maintenance_out, prefix),
      legal_aid: disposable_income_value(:legal_aid, prefix),
      income_tax: employment_deduction(:tax, prefix),
      national_insurance: employment_deduction(:national_insurance, prefix),
      employment_expenses: employment_deduction(:fixed_employment_deduction, prefix),
    }
    dependants_allowance = api_response.dig(:result_summary, :"#{prefix}disposable_income", :dependant_allowance)
    partner_allowance = api_response.dig(:result_summary, :"#{prefix}disposable_income", :partner_allowance)

    data[:dependants_allowance] = dependants_allowance if dependants_allowance&.positive?
    data[:partner_allowance] = partner_allowance if partner_allowance&.positive?
    data.transform_values { |v| monetise(v) }
  end

  def capital_row_items(prefix:)
    items = {
      property: api_response.dig(:result_summary, :"#{prefix}capital", :total_property),
      vehicles: api_response.dig(:result_summary, :"#{prefix}capital", :total_vehicle),
      liquid: api_response.dig(:result_summary, :"#{prefix}capital", :total_liquid),
      non_liquid: api_response.dig(:result_summary, :"#{prefix}capital", :total_non_liquid),
    }

    level_of_help == "controlled" ? items.except(:vehicles) : items
  end

  def capital_rows(prefix:)
    capital_row_items(prefix:).transform_values { |value| monetise(value) }
  end

  def main_home_rows(prefix:)
    main_home = capital_items(:properties, prefix).fetch(:main_home)
    disregard = main_home.fetch(:net_equity) - main_home.fetch(:assessed_equity)
    data = {
      value: monetise(main_home.fetch(:value)),
      mortgage: monetise(-main_home.fetch(:outstanding_mortgage)),
      disregards: monetise(-disregard),
    }

    transaction_allowance = main_home.fetch(:transaction_allowance)
    data[:deductions] = monetise(-transaction_allowance) if transaction_allowance.positive?

    data
  end

  def additional_property_rows(prefix:)
    home = capital_items(:properties, prefix)[:additional_properties].first
    data = {
      value: monetise(home.fetch(:value)),
      mortgage: monetise(-home.fetch(:outstanding_mortgage)),
    }

    transaction_allowance = home.fetch(:transaction_allowance)
    data[:deductions] = monetise(-transaction_allowance) if transaction_allowance.positive?

    data
  end

  def vehicle_rows(prefix:)
    vehicles = capital_items(:vehicles, prefix)
    {
      value: monetise(vehicles.sum(0) { _1.fetch(:value) }),
      outstanding_payments: monetise(-vehicles.sum(0) { _1.fetch(:loan_amount_outstanding) }),
      disregards: monetise(-vehicles.sum(0) { _1.fetch(:disregards_and_deductions) }),
    }
  end
end
