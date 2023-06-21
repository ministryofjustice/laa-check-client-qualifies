class CfeParamBuilders::SelfEmployment
  class << self
    def call(income_form)
      income_form.items.select { _1.income_type == "self_employment" }.map do |item|
        {
          income: {
            frequency: CfeParamBuilders::Employment::FREQUENCY_TRANSLATIONS.fetch(item.income_frequency),
            gross: item.gross_income,
            tax: CfeParamBuilders::Employment.express_as_negative_figure(item.income_tax),
            national_insurance: CfeParamBuilders::Employment.express_as_negative_figure(item.national_insurance),
          },
        }
      end
    end
  end
end
