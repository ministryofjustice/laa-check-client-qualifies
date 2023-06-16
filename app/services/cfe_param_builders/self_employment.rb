class CfeParamBuilders::SelfEmployment
  class << self
    def call(income_form)
      income_form.items.select { _1.income_type == "self_employment" }.map do |item|
        {
          income: {
            frequency: CfeParamBuilders::Employment::FREQUENCY_TRANSLATIONS.fetch(item.income_frequency),
            gross: item.gross_income,
            tax: item.income_tax * -1,
            national_insurance: item.national_insurance * -1,
          },
        }
      end
    end
  end
end
