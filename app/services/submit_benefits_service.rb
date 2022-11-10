class SubmitBenefitsService < BaseCfeService
  def self.call(cfe_estimate_id, cfe_session_data)
    new.call(cfe_estimate_id, cfe_session_data)
  end

  def call(cfe_estimate_id, cfe_session_data)
    model = Flow::BenefitsHandler.model(cfe_session_data)
    return if model.benefits.blank?

    state_benefits = model.benefits.map do |benefit|
      payments = Array.new(number_of_payments(benefit.benefit_frequency)) do |index|
        {
          date: Date.current - period(benefit.benefit_frequency, index),
          amount: benefit.benefit_amount,
          client_id: "",
        }
      end
      {
        name: benefit.benefit_type,
        payments:,
      }
    end

    cfe_connection.create_benefits(cfe_estimate_id, state_benefits)
  end

  # CFE expects to receive 12 payment instances if the payment frequency is weekly,
  # and 6 if it is fortnightly. If it does not receive that number it will not recognise
  # those frequencies. For 4-weekly or monthly it will accept 3 payments
  def number_of_payments(frequency)
    case frequency
    when "every_week"
      12
    when "every_two_weeks"
      6
    else
      3
    end
  end

  def period(frequency, index)
    case frequency
    when "every_week"
      index.weeks
    when "every_two_weeks"
      (index * 2).weeks
    else
      (index * 4).weeks
    end
  end
end
