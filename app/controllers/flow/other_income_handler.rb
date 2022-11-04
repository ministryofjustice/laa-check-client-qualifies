module Flow
  class OtherIncomeHandler
    class << self
      def model(session_data)
        OtherIncomeForm.new session_data.slice(*OtherIncomeForm::ATTRIBUTES.map(&:to_s))
      end

      def form(params, _session_data)
        OtherIncomeForm.new(params.require(:other_income_form)
          .permit(*OtherIncomeForm::ATTRIBUTES))
      end
    end
  end
end
