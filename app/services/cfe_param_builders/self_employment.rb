class CfeParamBuilders::SelfEmployment
  class << self
    FREQUENCY_TRANSLATIONS = {
      "every_week" => "weekly",
      "every_two_weeks" => "two_weekly",
      "every_four_weeks" => "four_weekly",
      "monthly" => "monthly",
      "three_months" => "quarterly",
      "year" => "annual",
    }.freeze

    def call(income_form)
      income_form.items.select { _1.income_type == "self_employment" }.map do |item|
        {
          income: {
            frequency: FREQUENCY_TRANSLATIONS.fetch(item.income_frequency),
            gross: item.gross_income,
            tax: item.income_tax * -1,
            national_insurance: item.national_insurance * -1,
          },
        }
      end
    end
  end
end
