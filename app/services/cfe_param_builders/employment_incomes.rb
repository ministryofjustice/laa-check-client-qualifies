module CfeParamBuilders
  class EmploymentIncomes
    def self.call(employment_form, applicant_form)
      # CFE wants to infer frequency of payment from gaps between payments.
      # So we use our knowledge of frequency to generate three appropriately-spaced,
      # representative payments, to allow CFE to make that inference
      [
        {
          name: "Job",
          client_id: "ID",
          receiving_only_statutory_sick_or_maternity_pay: applicant_form.employment_status == "receiving_statutory_pay",
          payments: Array.new(number_of_payments(employment_form)) do |index|
            {
              gross: (employment_form.gross_income * multiplier(employment_form)).round(2),
              tax: (-1 * employment_form.income_tax * multiplier(employment_form)).round(2),
              national_insurance: (-1 * employment_form.national_insurance * multiplier(employment_form)).round(2),
              client_id: "id-#{index}",
              date: Date.current - period(employment_form, index),
              benefits_in_kind: 0,
              net_employment_income: ((employment_form.gross_income - employment_form.income_tax - employment_form.national_insurance) * multiplier(employment_form)).round(2),
            }
          end,
        },
      ]
    end

    # CFE expects to receive 12 payment instances if the payment frequency is weekly,
    # and 6 if it is fortnightly. If it does not receive that number it will not recognise
    # those frequencies. For 4-weekly or monthly it will accept 3 payments
    def self.number_of_payments(form)
      case form.frequency
      when "week"
        12
      when "two_weeks"
        6
      else
        3
      end
    end

    # CFE doesn't understand about annual salary or 'total income in the last 3 months',
    # so for both those use cases we must convert the figures we have into what they would
    # be if they were paid as regular monthly income
    def self.multiplier(form)
      case form.frequency
      when "total"
        1.0 / 3
      else
        1
      end
    end

    def self.period(form, index)
      case form.frequency
      when "week"
        index.weeks
      when "two_weeks"
        (index * 2).weeks
      when "four_weeks"
        (index * 4).weeks
      else
        index.months
      end
    end
  end
end
