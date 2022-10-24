class IncomeSection
  class << self
    def all_steps
      %i[employment benefits monthly_income outgoings]
    end

    def steps_for(estimate)
      if estimate.passporting
        []
      else
        employment_step = estimate.employed ? [:employment] : []
        employment_step + %i[benefits monthly_income outgoings].map { [_1] }
      end
    end
  end
end
