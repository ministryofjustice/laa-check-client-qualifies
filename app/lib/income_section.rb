class IncomeSection
  class << self
    def all_steps
      %i[employment monthly_income outgoings]
    end

    def steps_for(estimate)
      if estimate.passporting
        []
      else
        employment_step = estimate.employed ? [:employment] : []
        [employment_step] + [%i[monthly_income outgoings]]
      end
    end
  end
end
