module CfeParamBuilders
  class StateBenefits
    HOUSING_BENEFIT_TYPE = "housing_benefit".freeze

    class << self
      def call(benefits_form, housing_benefit_details_form)
        general_benefits(benefits_form) + housing_benefit(housing_benefit_details_form)
      end

      def general_benefits(form)
        return [] if form.benefits.nil?

        form.benefits.map do |benefit|
          build_benefit(benefit.benefit_frequency, benefit.benefit_amount.to_f, benefit.benefit_type)
        end
      end

      def housing_benefit(form)
        return [] unless form

        [build_benefit(form.housing_benefit_frequency, form.housing_benefit_value.to_f, HOUSING_BENEFIT_TYPE)]
      end

      def build_benefit(frequency, value, type)
        payments = Array.new(number_of_payments(frequency)) do |index|
          {
            date: Date.current - period(frequency, index),
            amount: value,
            client_id: "",
          }
        end
        {
          name: type,
          payments:,
        }
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
        when "every_four_weeks"
          (index * 4).weeks
        else
          index.months
        end
      end
    end
  end
end
