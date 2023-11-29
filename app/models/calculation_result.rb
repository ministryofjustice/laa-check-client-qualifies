class CalculationResult
  CFE_MAX_VALUE = 999_999_999_999
  VALID_OVERALL_RESULTS = %w[eligible contribution_required ineligible].freeze
  Summary = Struct.new(:status, :upper_threshold, :lower_threshold, :no_upper_threshold, :no_lower_threshold, :section, keyword_init: true)

  include ActionView::Helpers::NumberHelper

  attr_reader :level_of_help

  def initialize(session_data)
    @api_response = session_data["api_response"].deep_symbolize_keys
    @level_of_help = session_data.fetch("level_of_help", "certificated")
    @check = Check.new(session_data)
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

  def any_calculations_performed?
    calculated?(:gross_income) || calculated?(:disposable_income) || calculated?(:capital)
  end

  def calculated?(section)
    api_response.dig(:result_summary, section, :proceeding_types).all? { VALID_OVERALL_RESULTS.include?(_1[:result]) }
  end

  def ineligible?(section)
    api_response.dig(:result_summary, section, :proceeding_types).all? { _1[:result] == "ineligible" }
  end

  def summary_data(section)
    raw_thresholds = api_response.dig(:result_summary, section, :proceeding_types, 0)
                             .slice(:upper_threshold, :lower_threshold)
    thresholds = raw_thresholds.transform_values { monetise(_1, precision: 0) }

    # The HTML IDs of the various accordion sections are dynamically generated within the
    # gov.uk component from the header text of those sections. To reference them, we need
    # to do the same, so that if that text changes, this code doesn't break.
    thresholds[:section] = case section
                           when :gross_income
                             "#{I18n.t('results.show.income_calculation').parameterize}-section"
                           when :disposable_income
                             "#{I18n.t('results.show.outgoings_calculation').parameterize}-section"
                           else
                             "#{I18n.t('results.show.capital_calculation').parameterize}-section"
                           end
    thresholds[:no_upper_threshold] = raw_thresholds[:upper_threshold] == CFE_MAX_VALUE
    thresholds[:no_lower_threshold] = raw_thresholds[:upper_threshold] == raw_thresholds[:lower_threshold]
    case api_response.dig(:result_summary, section, :proceeding_types, 0, :result)
    when "ineligible"
      Summary.new(**thresholds.merge(status: "ineligible"))
    when "contribution_required"
      Summary.new(**thresholds.merge(status: "contribution_required_and_overall_#{decision}"))
    else
      Summary.new(**thresholds.merge(status: "eligible"))
    end
  end

  def domestic_abuse_applicant
    @check.domestic_abuse_applicant
  end

  def immigration_or_asylum_type_upper_tribunal
    @check.immigration_or_asylum_type_upper_tribunal
  end

  def raw_capital_contribution
    api_response.dig(:result_summary, :overall_result, :capital_contribution)
  end

  def capital_contribution
    @capital_contribution ||= monetise(raw_capital_contribution)
  end

  def raw_income_contribution
    api_response.dig(:result_summary, :overall_result, :income_contribution)
  end

  def income_contribution
    @income_contribution ||= monetise(raw_income_contribution)
  end

  def total_calculated_gross_income
    monetise(api_response.dig(:result_summary, :gross_income, :combined_total_gross_income))
  end

  def gross_outgoings
    monetise(api_response.dig(:result_summary, :disposable_income, :combined_total_outgoings_and_allowances))
  end

  def gross_income_upper_threshold
    monetise(api_response.dig(:result_summary, :gross_income, :proceeding_types).map { |pt| pt.fetch(:upper_threshold) }.min)
  end

  def total_calculated_disposable_income
    monetise(api_response.dig(:result_summary, :disposable_income, :combined_total_disposable_income))
  end

  def total_calculated_capital
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
    monetise(api_response.dig(:result_summary, :partner_capital, :total_capital_with_smod))
  end

  def client_income_rows
    income_rows(prefix: "")
  end

  def has_partner?
    @has_partner ||= api_response.dig(:assessment, :partner_capital).present?
  end

  def pensioner_disregard_applied?
    api_response.dig(:result_summary, :capital, :pensioner_disregard_applied).positive? ||
      api_response.dig(:result_summary, :partner_capital, :pensioner_disregard_applied)&.positive?
  end

  def smod_applied?
    api_response.dig(:result_summary, :capital, :subject_matter_of_dispute_disregard).positive?
  end

  def partner_income_rows
    income_rows(prefix: "partner_")
  end

  def client_outgoing_rows
    rows = outgoing_rows(prefix: "")
    return rows if has_partner?

    rows.merge(household_outgoing_rows)
  end

  def partner_outgoing_rows
    outgoing_rows(prefix: "partner_")
  end

  def household_outgoing_rows
    data = { housing_costs: api_response.dig(:result_summary, :disposable_income, :net_housing_costs) }
    dependants_allowance = api_response.dig(:result_summary, :disposable_income, :dependant_allowance)
    data[:dependants_allowance] = dependants_allowance if @check.adult_dependants || @check.child_dependants
    data.transform_values { |v| monetise(v) }
  end

  def client_owns_main_home?
    capital_items(:properties).dig(:main_home, :value)&.positive?
  end

  def main_home_data
    main_home = capital_items(:properties, "").fetch(:main_home)
    property_data(main_home, property_type: :main)
  end

  def client_additional_property_data
    additional_property_data(prefix: "")
  end

  def partner_additional_property_data
    additional_property_data(prefix: "partner_")
  end

  def vehicle_owned?
    capital_items(:vehicles).any?
  end

  def display_household_vehicles
    capital_items(:vehicles, "").map do |vehicle|
      if vehicle[:in_regular_use]
        { value: monetise(vehicle[:value]),
          loan_amount_outstanding: monetise(-1 * vehicle[:loan_amount_outstanding]),
          disregards_and_deductions: monetise(-1 * vehicle[:disregards_and_deductions]),
          assessed_value: monetise(vehicle[:assessed_value]) }
      else
        { value: monetise(vehicle[:value]) }
      end
    end
  end

  def client_capital_rows
    capital_rows(prefix: "")
  end

  def client_capital_subtotal_rows
    rows = {
      total_capital: monetise(api_response.dig(:result_summary, :capital, :total_capital)),
      smod_non_property_disregard: monetise(-api_response.dig(:result_summary, :capital, :disputed_non_property_disregard)),
      pensioner_capital_disregard: monetise(-api_response.dig(:result_summary, :capital, :pensioner_disregard_applied)),
    }

    if has_partner? || !pensioner_disregard_applied?
      rows.except(:pensioner_capital_disregard)
    else
      rows
    end
  end

  def partner_capital_rows
    capital_rows(prefix: "partner_")
  end

  def pensioner_disregard_rows
    total_capital = api_response.dig(:result_summary, :capital, :total_capital_with_smod) +
      api_response.dig(:result_summary, :partner_capital, :total_capital_with_smod)
    disregarded = api_response.dig(:result_summary, :capital, :pensioner_disregard_applied) +
      api_response.dig(:result_summary, :partner_capital, :pensioner_disregard_applied)
    {
      total_capital: monetise(total_capital),
      pensioner_capital_disregard: monetise(-disregarded),
    }
  end

  def main_home_assessed_equity
    monetise(capital_items(:properties).dig(:main_home, :assessed_equity))
  end

  def client_additional_property_assessed_equity(index)
    monetise(capital_items(:properties)[:additional_properties][index].fetch(:assessed_equity))
  end

  def partner_additional_property_assessed_equity(index)
    monetise(partner_capital_items(:properties)[:additional_properties][index].fetch(:assessed_equity))
  end

  def household_vehicle_assessed_value(index)
    monetise(capital_items(:vehicles)[index][:assessed_value])
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

  def monetise(number, precision: 2)
    return I18n.t("generic.not_applicable") if number.nil? || number == CFE_MAX_VALUE

    number_to_currency(number, unit: "£", separator: ".", delimiter: ",", precision:)
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
      childcare_payments: disposable_income_value(:child_care, prefix),
      maintenance_out: disposable_income_value(:maintenance_out, prefix),
      legal_aid: disposable_income_value(:legal_aid, prefix),
      income_tax: employment_deduction(:tax, prefix),
      national_insurance: employment_deduction(:national_insurance, prefix),
      employment_expenses: employment_deduction(:fixed_employment_deduction, prefix),
    }

    data.delete(:childcare_payments) unless @check.eligible_for_childcare_costs?

    partner_allowance = api_response.dig(:result_summary, :"#{prefix}disposable_income", :partner_allowance)

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

  def additional_property_data(prefix:)
    properties = capital_items(:properties, prefix)
    return [] unless properties

    properties[:additional_properties].map do |additional_property|
      property_data(additional_property, property_type: :additional)
    end
  end

  def property_data(property, property_type:)
    data = {
      value: property.fetch(:value),
      mortgage: -property.fetch(:outstanding_mortgage),
      transaction_allowance: -property.fetch(:transaction_allowance),
      smod_allowance: -property.fetch(:smod_allowance),
      main_home_disregard: -property.fetch(:main_home_equity_disregard),
    }

    data.each_key do |key|
      data.delete(key) if data[key].zero?
    end

    monetised = data.transform_values { monetise(_1) }

    if property_type == :additional && property.fetch(:percentage_owned) < 100 && !data[:smod_allowance]
      {
        type: :partially_owned_minimal,
        rows: monetised,
        percentage_owned: property.fetch(:percentage_owned),
      }
    elsif property.fetch(:percentage_owned) < 100
      {
        type: :partially_owned,
        upper_rows: monetised.slice(:value, :mortgage, :transaction_allowance),
        percentage_owned: property.fetch(:percentage_owned),
        net_equity: monetise(property.fetch(:net_equity)),
        lower_rows: monetised.slice(:smod_allowance, :main_home_disregard),
      }
    else
      {
        type: :fully_owned,
        rows: monetised,
      }
    end
  end
end
