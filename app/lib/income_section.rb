class IncomeSection
  BENEFIT_STEPS = %i[benefit_yesno benefit_details].freeze
  BENEFIT_MORE = %i[benefits_more].freeze

  class << self
    def all_steps
      %i[employment benefit_yesno benefit_details benefits_more benefit_remove edit_benefit monthly_income outgoings]
    end

    def step_should_save?(_model, step)
      step.in? %i[employment benefit_details benefits_more edit_benefit benefit_remove outgoings]
    end

    def steps_for(estimate)
      benefit_steps = if estimate.has_benefits
                        if estimate.more_benefits
                          [BENEFIT_STEPS] + [BENEFIT_MORE] + [BENEFIT_STEPS.last]
                        else
                          [BENEFIT_STEPS] + [BENEFIT_MORE]
                        end
                      else
                        [[BENEFIT_STEPS.first]].freeze
                      end

      if estimate.passporting
        benefit_steps
      else
        employment_step = estimate.employed ? [:employment] : []

        [employment_step] + benefit_steps + [%i[monthly_income outgoings]]
      end
    end
  end
end
