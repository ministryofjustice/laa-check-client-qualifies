module CfeParamBuilders
  class RegularTransactions
    def self.call(income_form, outgoings_form)
      income = build_payments(CFE_INCOME_TRANSLATIONS, income_form, :credit)

      outgoings = build_payments(CFE_OUTGOINGS_TRANSLATIONS, outgoings_form, :debit)

      income + outgoings
    end

    CFE_FREQUENCIES = {
      "every_week" => :weekly,
      "every_two_weeks" => :two_weekly,
      "every_four_weeks" => :four_weekly,
      "monthly" => :monthly,
      "total" => :three_monthly,
    }.freeze

    CFE_INCOME_TRANSLATIONS = {
      friends_or_family: :friends_or_family,
      maintenance_in: :maintenance,
      property_or_lodger: :property_or_lodger,
      pension: :pension,
    }.freeze

    CFE_OUTGOINGS_TRANSLATIONS = {
      rent_or_mortgage: :housing_payments,
      child_care: :childcare_payments,
      maintenance_out: :maintenance_payments,
      legal_aid: :legal_aid_payments,
    }.freeze

    def self.build_payments(cfe_translations, form, operation)
      cfe_translations.select { |_cfe_name, local_name| form.send("#{local_name}_value")&.positive? }
                      .map do |cfe_name, local_name|
        {
          operation:,
          category: cfe_name,
          frequency: CFE_FREQUENCIES[form.send("#{local_name}_frequency")],
          amount: form.send("#{local_name}_value"),
        }
      end
    end
  end
end
