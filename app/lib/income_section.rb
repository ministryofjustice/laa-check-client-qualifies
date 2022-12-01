class IncomeSection
  class << self
    def all_steps
      %i[employment housing_benefit housing_benefit_details benefits other_income outgoings]
    end

    def steps_for(estimate)
      if estimate.passporting
        []
      else
        employment_steps(estimate) + housing_benefit_steps(estimate) + other_steps
      end
    end

    def employment_steps(estimate)
      estimate.employed ? [[:employment]] : []
    end

    def other_steps
      %i[benefits other_income outgoings].map { [_1] }
    end

    def housing_benefit_steps(estimate)
      estimate.housing_benefit ? [%i[housing_benefit housing_benefit_details]] : [%i[housing_benefit]]
    end
  end
end
