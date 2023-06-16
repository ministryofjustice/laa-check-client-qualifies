class CfeParamBuilders::Employment
  FREQUENCY_TRANSLATIONS = {
    "every_week" => "weekly",
    "every_two_weeks" => "two_weekly",
    "every_four_weeks" => "four_weekly",
    "monthly" => "monthly",
    "three_months" => "three_monthly",
    "year" => "annually",
  }.freeze

  class << self
    def call(income_form)
      income_form.items.reject { _1.income_type == "self_employment" }.map do |item|
        {
          receiving_only_statutory_sick_or_maternity_pay: item.income_type == "statutory_pay",
          income: {
            frequency: FREQUENCY_TRANSLATIONS.fetch(item.income_frequency),
            gross: item.gross_income,
            benefits_in_kind: 0,
            tax: item.income_tax * -1,
            national_insurance: item.national_insurance * -1,
          },
        }
      end
    end
  end
end
