class CalculationResult
  CFE_MAX_VALUE = 999_999_999_999
  Summary = Struct.new(:status, :upper_threshold, :lower_threshold, :no_upper_threshold, :no_lower_threshold, :section, keyword_init: true)

  include ActionView::Helpers::NumberHelper

  attr_reader :level_of_help

  delegate :decision, :calculated?, :has_partner?, :ineligible?, :capital_items,
           :raw_capital_contribution, :raw_income_contribution,
           :pensioner_disregard_applied?, :smod_applied?, to: :@api_response

  def initialize(session_data)
    @api_response = CfeResult.new session_data["api_response"]
    @level_of_help = session_data.fetch("level_of_help", "certificated")
    @check = Check.new(session_data)
  end

  def any_calculations_performed?
    calculated?(:gross_income) || calculated?(:disposable_income) || calculated?(:capital)
  end

  def summary_data(section)
    raw_thresholds = api_response.raw_thresholds(section)
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
    case api_response.result_for(section)
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

  def capital_contribution
    @capital_contribution ||= monetise(api_response.raw_capital_contribution)
  end

  def income_contribution
    @income_contribution ||= monetise(api_response.raw_income_contribution)
  end

  def total_calculated_gross_income
    monetise(api_response.raw_total_calculated_gross_income)
  end

  def gross_outgoings
    monetise(api_response.raw_gross_outgoings)
  end

  def gross_income_upper_threshold
    monetise(api_response.raw_gross_income_upper_threshold)
  end

  def total_calculated_disposable_income
    monetise(api_response.raw_total_calculated_disposable_income)
  end

  def total_calculated_capital
    monetise(api_response.raw_total_calculated_capital)
  end

  def disposable_income_upper_threshold
    monetise(api_response.raw_disposable_income_upper_threshold)
  end

  def capital_upper_threshold
    monetise(api_response.raw_capital_upper_threshold)
  end

  def client_assessed_capital
    monetise(api_response.raw_client_assessed_capital)
  end

  def partner_assessed_capital
    monetise(api_response.raw_partner_assessed_capital)
  end

  def client_income_rows
    income_rows(prefix: "")
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
    data = { housing_costs: api_response.disposable_income_result_row(:net_housing_costs) }
    dependants_allowance = api_response.disposable_income_result_row(:dependant_allowance)
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
    rows = api_response.client_capital_subtotal_rows.transform_values { |x| monetise(x) }

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
    api_response.pensioner_disregard_rows.transform_values { |c| monetise(c) }
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

  def monetise(number, precision: 2)
    return I18n.t("generic.not_applicable") if number.nil? || number == CFE_MAX_VALUE

    number_to_currency(number, unit: "£", separator: ".", delimiter: ",", precision:)
  end

  def income_rows(prefix:)
    api_response.raw_income_rows(prefix:).transform_values { |v| monetise(v) }
  end

  def outgoing_rows(prefix:)
    data = {
      childcare_payments: api_response.disposable_income_value(:child_care, prefix),
      maintenance_out: api_response.disposable_income_value(:maintenance_out, prefix),
      legal_aid: api_response.disposable_income_value(:legal_aid, prefix),
      income_tax: api_response.employment_deduction(:tax, prefix),
      national_insurance: api_response.employment_deduction(:national_insurance, prefix),
      employment_expenses: api_response.employment_deduction(:fixed_employment_deduction, prefix),
    }

    data.delete(:childcare_payments) unless @check.eligible_for_childcare_costs?

    partner_allowance = api_response.partner_allowance(prefix)

    data[:partner_allowance] = partner_allowance if partner_allowance&.positive?

    data.transform_values { |v| monetise(v) }
  end

  def capital_row_items(prefix:)
    items = api_response.capital_row_items(prefix:)

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
