class CfeResult
  VALID_OVERALL_RESULTS = %w[eligible contribution_required ineligible].freeze

  def initialize(api_response)
    @api_response = api_response.deep_symbolize_keys
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
    api_response.dig(:result_summary, section, :proceeding_types).any? { VALID_OVERALL_RESULTS.include?(_1[:result]) }
  end

  def raw_thresholds(section)
    api_response.dig(:result_summary, section, :proceeding_types, 0)
                                 .slice(:upper_threshold, :lower_threshold)
  end

  def result_for(section)
    api_response.dig(:result_summary, section, :proceeding_types, 0, :result)
  end

  def raw_total_calculated_gross_income
    api_response.dig(:result_summary, :gross_income, :combined_total_gross_income)
  end

  def raw_capital_contribution
    api_response.dig(:result_summary, :overall_result, :capital_contribution)
  end

  def raw_income_contribution
    api_response.dig(:result_summary, :overall_result, :income_contribution)
  end

  def raw_total_calculated_disposable_income
    api_response.dig(:result_summary, :disposable_income, :combined_total_disposable_income)
  end

  def raw_total_calculated_capital
    # # If the pensioner_capital_disregard is applied, it is applied by CFE in full even when the disregard is
    # # greater than the client's total capital value. This can lead to the CFE 'assessed capital' figure
    # # being a negative number, which is unsuitable for display to the end user.
    # # Therefore we must correct the CFE result to display a zero if it comes back negative.
    [api_response.dig(:result_summary, :capital, :combined_assessed_capital), 0].compact.max
  end

  def raw_income_rows(prefix:)
    {
      employment_income: api_response.dig(:result_summary, :"#{prefix}disposable_income", :employment_income, :gross_income),
      benefits: api_response.dig(:assessment, :"#{prefix}gross_income", :state_benefits, :monthly_equivalents, :all_sources),
      friends_and_family: extract_other_income(:friends_or_family, prefix),
      maintenance: extract_other_income(:maintenance_in, prefix),
      property_or_lodger: extract_other_income(:property_or_lodger, prefix),
      pension: extract_other_income(:pension, prefix),
      student_finance: api_response.dig(:assessment, :"#{prefix}gross_income", :irregular_income, :monthly_equivalents, :student_loan),
      other: api_response.dig(:assessment, :"#{prefix}gross_income", :irregular_income, :monthly_equivalents, :unspecified_source),
    }
  end

  def has_partner?
    @has_partner ||= api_response.dig(:assessment, :partner_capital).present?
  end

  def raw_gross_income_upper_threshold
    api_response.dig(:result_summary, :gross_income, :proceeding_types).map { |pt| pt.fetch(:upper_threshold) }.min
  end

  def ineligible?(section)
    api_response.dig(:result_summary, section, :proceeding_types).all? { _1[:result] == "ineligible" }
  end

  def disposable_income_value(key, prefix)
    api_response.dig(:assessment, :"#{prefix}disposable_income",
                     :monthly_equivalents, :all_sources, key)
  end

  def employment_deduction(key, prefix)
    value = api_response.dig(:result_summary, :"#{prefix}disposable_income", :employment_income, key)
    0 - value if value.present?
  end

  def partner_allowance(prefix)
    api_response.dig(:result_summary, :"#{prefix}disposable_income", :partner_allowance)
  end

  def disposable_income_result_row(row)
    api_response.dig(:result_summary, :disposable_income, row)
  end

  def raw_gross_outgoings
    api_response.dig(:result_summary, :disposable_income, :combined_total_outgoings_and_allowances)
  end

  def raw_disposable_income_upper_threshold
    api_response.dig(:result_summary, :disposable_income, :proceeding_types).map { |pt| pt.fetch(:upper_threshold) }.min
  end

  def capital_items(key, prefix = "")
    api_response.dig(:assessment, :"#{prefix}capital", :capital_items, key)
  end

  def capital_row_items(prefix:)
    {
      property: api_response.dig(:result_summary, :"#{prefix}capital", :total_property),
      vehicles: api_response.dig(:result_summary, :"#{prefix}capital", :total_vehicle),
      liquid: api_response.dig(:result_summary, :"#{prefix}capital", :total_liquid),
      non_liquid: api_response.dig(:result_summary, :"#{prefix}capital", :total_non_liquid),
    }
  end

  def client_capital_subtotal_rows
    {
      total_capital: api_response.dig(:result_summary, :capital, :total_capital),
      smod_non_property_disregard: -api_response.dig(:result_summary, :capital, :disputed_non_property_disregard),
      pensioner_capital_disregard: -api_response.dig(:result_summary, :capital, :pensioner_disregard_applied),
    }
  end

  def pensioner_disregard_applied?
    api_response.dig(:result_summary, :capital, :pensioner_disregard_applied).positive? ||
      api_response.dig(:result_summary, :partner_capital, :pensioner_disregard_applied)&.positive?
  end

  def smod_applied?
    api_response.dig(:result_summary, :capital, :subject_matter_of_dispute_disregard).positive?
  end

  def raw_capital_upper_threshold
    api_response.dig(:result_summary, :capital, :proceeding_types).map { |pt| pt.fetch(:upper_threshold) }.min
  end

  def raw_client_assessed_capital
    api_response.dig(:result_summary, :capital, :total_capital_with_smod)
  end

  def raw_partner_assessed_capital
    api_response.dig(:result_summary, :partner_capital, :total_capital_with_smod)
  end

  def pensioner_disregard_rows
    total_capital = api_response.dig(:result_summary, :capital, :total_capital_with_smod) +
      api_response.dig(:result_summary, :partner_capital, :total_capital_with_smod)
    disregarded = api_response.dig(:result_summary, :capital, :pensioner_disregard_applied) +
      api_response.dig(:result_summary, :partner_capital, :pensioner_disregard_applied)
    {
      total_capital:,
      pensioner_capital_disregard: -disregarded,
    }
  end

private

  attr_reader :api_response

  def extract_other_income(key, prefix)
    api_response.dig(:assessment, :"#{prefix}gross_income", :other_income, :monthly_equivalents, :all_sources, key)
  end
end
