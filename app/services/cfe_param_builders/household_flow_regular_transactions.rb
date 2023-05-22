module CfeParamBuilders
  class HouseholdFlowRegularTransactions
    def self.call(income_form, outgoings_form, housing_form)
      income = build_payments(CFE_INCOME_TRANSLATIONS, income_form, :credit)

      outgoings = build_payments(CFE_OUTGOINGS_TRANSLATIONS, outgoings_form, :debit)

      housing = build_housing_payments(housing_form)

      income + outgoings + housing
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

    def self.build_housing_payments(housing_form)
      case housing_form
      when MortgageOrLoanPaymentForm
        [
          {
            operation: :debit,
            category: :rent_or_mortgage,
            frequency: CFE_FREQUENCIES[housing_form.housing_payments_loan_frequency],
            amount: housing_form.housing_loan_payments,
          },
        ]
      when HousingCostsForm
        [
          {
            operation: :debit,
            category: :rent_or_mortgage,
            frequency: CFE_FREQUENCIES[housing_form.housing_payments_frequency],
            amount: housing_form.housing_payments,
          },
        ]
      else
        []
      end
    end
  end
end
