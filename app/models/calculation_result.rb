class CalculationResult
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

  def client_income_rows
    {
      employment_income: extract_money(:result_summary, :disposable_income, :employment_income, :net_employment_income),
      benefits: extract_money(:assessment, :gross_income, :state_benefits, :monthly_equivalents, :all_sources),
      friends_and_family: extract_other_money(:friends_or_family),
      maintenance: extract_other_money(:maintenance_in),
      property_or_lodger: extract_other_money(:property_or_lodger),
      pension: extract_other_money(:pension),
      student_finance: extract_money(:assessment, :gross_income, :irregular_income, :monthly_equivalents, :student_loan),
      other: monetise(0), # TODO: CFE does not currently return the 'other' figure, and we should pull this from CFE
      # so users can verify that correct figures have been used in calculation
    }
  end

private

  attr_reader :api_response

  def extract_money(*path)
    monetise(api_response.dig(*path))
  end

  def extract_other_money(key)
    extract_money(:assessment, :gross_income, :other_income, :monthly_equivalents, :all_sources, key)
  end

  def monetise(number)
    return "N/A" if number.nil?

    number_to_currency(number, unit: "£", separator: ".", delimiter: ",", precision: 2)
  end
end
