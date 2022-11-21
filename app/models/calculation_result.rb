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
    sum = if has_partner?
            api_response.dig(:result_summary, :gross_income, :total_gross_income) +
              api_response.dig(:result_summary, :partner_gross_income, :total_gross_income)
          else
            api_response.dig(:result_summary, :gross_income, :total_gross_income)
          end
    monetise(sum)
  end

  def gross_outgoings
    sum = if has_partner?
            api_response.dig(:result_summary, :disposable_income, :total_outgoings_and_allowances) +
              api_response.dig(:result_summary, :partner_disposable_income, :total_outgoings_and_allowances)
          else
            api_response.dig(:result_summary, :disposable_income, :total_outgoings_and_allowances)
          end
    monetise(sum)
  end

  def gross_income_upper_threshold
    monetise(api_response.dig(:result_summary, :gross_income, :proceeding_types).map { |pt| pt.fetch(:upper_threshold) }.min)
  end

  def total_disposable_income
    sum = if has_partner?
            api_response.dig(:result_summary, :disposable_income, :total_disposable_income) +
              api_response.dig(:result_summary, :partner_disposable_income, :total_disposable_income)
          else
            api_response.dig(:result_summary, :disposable_income, :total_disposable_income)
          end
    monetise(sum)
  end

  def total_assessed_capital
    sum = if has_partner?
            api_response.dig(:result_summary, :capital, :assessed_capital) +
              api_response.dig(:result_summary, :partner_capital, :assessed_capital)
          else
            api_response.dig(:result_summary, :capital, :assessed_capital)
          end
    monetise([sum, 0].compact.max)
  end

  def disposable_income_upper_threshold
    monetise(api_response.dig(:result_summary, :disposable_income, :proceeding_types).map { |pt| pt.fetch(:upper_threshold) }.min)
  end

  def capital_upper_threshold
    monetise(api_response.dig(:result_summary, :capital, :proceeding_types).map { |pt| pt.fetch(:upper_threshold) }.min)
  end

  def client_assessed_capital
    # If the pensioner_capital_disregard is applied, it is applied by CFE in full even when the disregard is
    # greater than the client's total capital value. This can lead to the CFE 'assessed capital' figure
    # being a negative number, which is unsuitable for display to the end user.
    # Therefore we must correct the CFE result to display a zero if it comes back negative.
    cfe_result = api_response.dig(:result_summary, :capital, :assessed_capital)
    monetise([cfe_result, 0].compact.max)
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
    income_rows
  end

  def has_partner?
    @has_partner ||= api_response.dig(:assessment, :partner_capital).present?
  end

  def partner_income_rows
    income_rows(prefix: "partner_")
  end

  def client_outgoing_rows
    outgoing_rows
  end

  def partner_outgoing_rows
    outgoing_rows(prefix: "partner_")
  end

  def client_owns_main_home?
    capital_items(:properties)[:main_home].present?
  end

  def client_main_home_rows
    main_home_rows
  end

  def client_owns_additional_property?
    capital_items(:properties)[:additional_properties].present?
  end

  def partner_owns_additional_property?
    capital_items(:properties, "partner_")&.dig(:additional_properties).present?
  end

  def client_additional_property_rows
    additional_property_rows
  end

  def partner_additional_property_rows
    additional_property_rows(prefix: "partner_")
  end

  def vehicle_owned?
    capital_items(:vehicles).any?
  end

  def partner_vehicle_owned?
    capital_items(:vehicles, "partner_")&.any?
  end

  def client_vehicle_rows
    vehicle_rows
  end

  def partner_vehicle_rows
    vehicle_rows(prefix: "partner_")
  end

  def client_capital_rows
    capital_rows
  end

  def client_capital_subtotal_rows
    capital_subtotal_rows
  end

  def partner_capital_rows
    capital_rows(prefix: "partner_")
  end

  def partner_capital_subtotal_rows
    capital_subtotal_rows(prefix: "partner_")
  end

private

  attr_reader :api_response

  def capital_items(key, prefix = nil)
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

  def income_rows(prefix: nil)
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

  def outgoing_rows(prefix: nil)
    data = {
      housing_costs: disposable_income_value(:rent_or_mortgage, prefix),
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

  def capital_rows(prefix: nil)
    data = {
      liquid: api_response.dig(:result_summary, :"#{prefix}capital", :total_liquid),
      non_liquid: api_response.dig(:result_summary, :"#{prefix}capital", :total_non_liquid),
      property: api_response.dig(:result_summary, :"#{prefix}capital", :total_property),
      vehicles: api_response.dig(:result_summary, :"#{prefix}capital", :total_vehicle),
    }
    data.transform_values { |value| monetise(value) }
  end

  def capital_subtotal_rows(prefix: nil)
    data = {
      total_capital: api_response.dig(:result_summary, :"#{prefix}capital", :total_capital),
      pensioner_capital_disregard: api_response.dig(:result_summary, :"#{prefix}capital", :pensioner_capital_disregard),
      smod_disregard: api_response.dig(:result_summary, :"#{prefix}capital", :subject_matter_of_dispute_disregard),
    }

    data.transform_values { |value| monetise(value) }
  end

  def main_home_rows(prefix: nil)
    data = {
      main_home_value: :value,
      main_home_mortgage: :outstanding_mortgage,
      main_home_disregard: :main_home_equity_disregard,
      main_home_equity: :assessed_equity,
    }
    data.transform_values { |v| monetise(capital_items(:properties, prefix).dig(:main_home, v)) }
  end

  def additional_property_rows(prefix: nil)
    data = {
      additional_property_value: :value,
      additional_property_mortgage: :outstanding_mortgage,
      additional_property_equity: :assessed_equity,
    }
    data.transform_values { |v| monetise(capital_items(:properties, prefix)[:additional_properties].first[v]) }
  end

  def vehicle_rows(prefix: nil)
    data = {
      vehicle_value: capital_items(:vehicles, prefix).sum(0) { |z| z.fetch(:value) },
      vehicle_outstanding_payments: capital_items(:vehicles, prefix).sum(0) { |z| z.fetch(:loan_amount_outstanding) },
      vehicle_disregards: vehicle_disregards(prefix),
      vehicle_assessed_value: capital_items(:vehicles).sum(0) { |z| z.fetch(:assessed_value) },
    }

    data.transform_values { |value| monetise(value) }
  end

  def vehicle_disregards(prefix)
    value = capital_items(:vehicles, prefix).sum(0) { |z| z.fetch(:value) }
    pcp = capital_items(:vehicles, prefix).sum(0) { |z| z.fetch(:loan_amount_outstanding) }
    assessed_value = capital_items(:vehicles, prefix).sum(0) { |z| z.fetch(:assessed_value) }
    value - pcp - assessed_value
  end
end
