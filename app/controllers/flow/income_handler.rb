module Flow
  class IncomeHandler
    MONTHLY_INCOME_ATTRIBUTES = (MonthlyIncomeForm::INCOME_ATTRIBUTES + [:monthly_incomes]).freeze

    class << self
      def model(session_data)
        MonthlyIncomeForm.new session_data.slice(*MONTHLY_INCOME_ATTRIBUTES)
      end

      def form(params)
        MonthlyIncomeForm.new(params.require(:monthly_income_form)
          .permit(*MonthlyIncomeForm::INCOME_ATTRIBUTES, monthly_incomes: []))
      end

      def save_data(cfe_connection, estimate_id, income_form, outgoings_form)
        cfe_connection.create_student_loan estimate_id, income_form.student_finance if income_form.student_finance.present?
        payments = []
        if income_form.friends_or_family.present?
          payments << { operation: :credit,
                        category: :friends_or_family,
                        frequency: :monthly,
                        amount: income_form.friends_or_family }
        end
        if income_form.maintenance.present?
          payments << { operation: :credit,
                        category: :maintenance_in,
                        frequency: :monthly,
                        amount: income_form.maintenance }
        end
        if outgoings_form&.housing_payments.present?
          payments << { operation: :debit,
                        category: :rent_or_mortgage,
                        frequency: :monthly,
                        amount: outgoings_form.housing_payments }
        end
        cfe_connection.create_regular_payments(estimate_id, payments) if payments.any?
      end
    end
  end
end
