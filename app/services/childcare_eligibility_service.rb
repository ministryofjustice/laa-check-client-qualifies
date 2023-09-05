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
      is_student?(check.student_finance_value) || in_work?(check.incomes)
    end

    def partner_eligible?(check)
      is_student?(check.partner_student_finance_value) || in_work?(check.partner_incomes)
    end

    def is_student?(student_finance_amount)
      student_finance_amount.positive?
    end

    def in_work?(incomes)
      incomes&.any? { _1.income_type != "statutory_pay" } || false
    end
  end
end
