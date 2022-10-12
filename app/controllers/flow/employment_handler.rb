module Flow
  class EmploymentHandler
    class << self
      def model(session_data)
        EmploymentForm.new session_data.slice(*EmploymentForm::EMPLOYMENT_ATTRIBUTES.map(&:to_s))
      end

      def form(params, _session_data)
        EmploymentForm.new(params.require(:employment_form)
          .permit(*EmploymentForm::EMPLOYMENT_ATTRIBUTES))
      end

      # def save_data(cfe_connection, estimate_id, form, _session_data)
      #   # CFE wants to infer frequency of payment from gaps between payments.
      #   # So we use our knowledge of frequency to generate three appropriately-spaced,
      #   # representative payments, to allow CFE to make that inference
      #   employment_data = [
      #     {
      #       name: "Job",
      #       client_id: "ID",
      #       payments: Array.new(3) do |index|
      #         {
      #           gross: (form.gross_income * multiplier(form)).round(2),
      #           tax: (-1 * form.income_tax * multiplier(form)).round(2),
      #           national_insurance: (-1 * form.national_insurance * multiplier(form)).round(2),
      #           client_id: "id-#{index}",
      #           date: Date.current - period(form, index),
      #           benefits_in_kind: 0,
      #           net_employment_income: ((form.gross_income - form.income_tax - form.national_insurance) * multiplier(form)).round(2),
      #         }
      #       end,
      #     },
      #   ]
      #
      #   cfe_connection.create_employment(estimate_id, employment_data)
      # end

    private

      # # CFE doesn't understand about annual salary or 'total income in the last 3 months',
      # # so for both those use cases we must convert the figures we have into what they would
      # # be if they were paid as regular monthly income
      # def multiplier(form)
      #   case form.frequency
      #   when "annually"
      #     1.0 / 12
      #   when "total"
      #     1.0 / 3
      #   else
      #     1
      #   end
      # end
      #
      # def period(form, index)
      #   case form.frequency
      #   when "annually", "total", "monthly"
      #     index.months
      #   when "week"
      #     index.weeks
      #   when "two_weeks"
      #     (index * 2).weeks
      #   when "four_weeks"
      #     (index * 4).weeks
      #   end
      # end
    end
  end
end
