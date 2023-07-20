class ChildcareEligibilityService
  class << self
    def call(check)
      dependants?(check) &&
        client_eligible?(check) &&
        (!check.partner || partner_eligible?(check))
    end

    def dependants?(check)
      check.child_dependants
    end

    def client_eligible?(check)
      is_student?(check.student_finance_value) || in_work?(check.employment_status, check.incomes, check.session_data)
    end

    def partner_eligible?(check)
      is_student?(check.partner_student_finance_value) || in_work?(check.partner_employment_status, check.partner_incomes, check.session_data)
    end

    def is_student?(student_finance_amount)
      student_finance_amount.positive?
    end

    def in_work?(employment_status, incomes, session_data)
      if FeatureFlags.enabled?(:self_employed, session_data)
        incomes&.any? { _1.income_type != "statutory_pay" } || false
      else
        employment_status == "in_work"
      end
    end
  end
end
