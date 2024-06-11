module CfeParamBuilders
  class RegularTransactions
    def self.call(income_form, outgoings_form, benefit_details_form, housing_form = nil)
      income = build_payments(CFE_INCOME_TRANSLATIONS, income_form, :credit)

      outgoings = build_payments(CFE_OUTGOINGS_TRANSLATIONS, outgoings_form, :debit)

      housing = build_housing_payments(housing_form)

      benefits = build_benefits(benefit_details_form)

      housing_benefit = build_housing_benefits(housing_form)

      income + outgoings + housing + benefits + housing_benefit
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
      return [] if form.nil?

      cfe_translations.select { |_cfe_name, local_name| value(form, local_name).to_i.positive? }
                      .map do |cfe_name, local_name|
        {
          operation:,
          category: cfe_name,
          frequency: CFE_FREQUENCIES.fetch(form.send("#{local_name}_frequency")),
          amount: value(form, local_name),
        }
      end
    end

    def self.value(form, local_name)
      form.send("#{local_name}_conditional_value") if form.send("#{local_name}_relevant")
    end

    def self.build_housing_payments(housing_form)
      case housing_form
      when MortgageOrLoanPaymentForm
        return [] if housing_form.housing_loan_payments.to_i.zero?

        [
          {
            operation: :debit,
            category: :rent_or_mortgage,
            frequency: CFE_FREQUENCIES.fetch(housing_form.housing_payments_loan_frequency),
            amount: housing_form.housing_loan_payments,
          },
        ]
      when HousingCostsForm
        return [] if housing_form.housing_payments.to_i.zero?

        [
          {
            operation: :debit,
            category: :rent_or_mortgage,
            frequency: CFE_FREQUENCIES.fetch(housing_form.housing_payments_frequency),
            amount: housing_form.housing_payments,
          },
        ]
      else
        []
      end
    end

    def self.build_benefits(benefit_details_form)
      return [] unless benefit_details_form

      benefit_details_form.items.map do |benefit|
        {
          operation: :credit,
          category: "benefits",
          frequency: CFE_FREQUENCIES.fetch(benefit.benefit_frequency),
          amount: benefit.benefit_amount,
        }
      end
    end

    def self.build_housing_benefits(housing_form)
      if housing_form.is_a?(HousingCostsForm) && housing_form.is_housing_benefit_relevant?
        [
          {
            operation: :credit,
            category: :housing_benefit,
            frequency: CFE_FREQUENCIES.fetch(housing_form.housing_benefit_frequency),
            amount: housing_form.housing_benefit_value,
          },
        ]
      else
        []
      end
    end
  end
end
