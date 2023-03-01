class IncomeSection
  class << self
    def all_steps
      %i[employment benefits other_income outgoings housing]
    end

    def steps_for(estimate)
      if estimate.passporting || estimate.asylum_support_and_upper_tribunal?
        []
      else
        employment_steps(estimate) + other_steps
      end
    end

  private

    def employment_steps(estimate)
      estimate.employed ? [[:employment]] : []
    end

    def other_steps
      %i[benefits other_income outgoings housing].map { [_1] }
    end
  end
end
