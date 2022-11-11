class SubmitEmploymentIncomeService < BaseCfeService
  def self.call(cfe_estimate_id, cfe_session_data)
    new.call(cfe_estimate_id, cfe_session_data)
  end

  def call(cfe_estimate_id, cfe_session_data)
    form = Flow::Handler.model_from_session(:employment, cfe_session_data)
    return if form.gross_income.blank?

    # CFE wants to infer frequency of payment from gaps between payments.
    # So we use our knowledge of frequency to generate three appropriately-spaced,
    # representative payments, to allow CFE to make that inference
    employment_data = [
      {
        name: "Job",
        client_id: "ID",
        payments: Array.new(number_of_payments(form)) do |index|
          {
            gross: (form.gross_income * multiplier(form)).round(2),
            tax: (-1 * form.income_tax * multiplier(form)).round(2),
            national_insurance: (-1 * form.national_insurance * multiplier(form)).round(2),
            client_id: "id-#{index}",
            date: Date.current - period(form, index),
            benefits_in_kind: 0,
            net_employment_income: ((form.gross_income - form.income_tax - form.national_insurance) * multiplier(form)).round(2),
          }
        end,
      },
    ]

    cfe_connection.create_employment(cfe_estimate_id, employment_data)
  end

  # CFE expects to receive 12 payment instances if the payment frequency is weekly,
  # and 6 if it is fortnightly. If it does not receive that number it will not recognise
  # those frequencies. For 4-weekly or monthly it will accept 3 payments
  def number_of_payments(form)
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
  def multiplier(form)
    case form.frequency
    when "annually"
      1.0 / 12
    when "total"
      1.0 / 3
    else
      1
    end
  end

  def period(form, index)
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
