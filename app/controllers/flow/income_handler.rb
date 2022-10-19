module Flow
  class IncomeHandler
    class << self
      def model(session_data, estimate_model)
        if estimate_model.employed
          EmploymentForm.new session_data.slice(*EmploymentForm::EMPLOYMENT_ATTRIBUTES.map(&:to_s))
        else
          MonthlyIncomeForm.new session_data.slice(*MonthlyIncomeForm::ALL_ATTRIBUTES.map(&:to_s))
        end
      end
    end
  end
end
