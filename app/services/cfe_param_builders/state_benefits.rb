module CfeParamBuilders
  class StateBenefits
    def self.call(form)
      form.benefits.map do |benefit|
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
    end

    # CFE expects to receive 12 payment instances if the payment frequency is weekly,
    # and 6 if it is fortnightly. If it does not receive that number it will not recognise
    # those frequencies. For 4-weekly or monthly it will accept 3 payments
    def self.number_of_payments(frequency)
      case frequency
      when "every_week"
        12
      when "every_two_weeks"
        6
      else
        3
      end
    end

    def self.period(frequency, index)
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
end
