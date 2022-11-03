class StepsHelper
  class << self
    def all_possible_steps
      all_sections.map(&:all_steps).reduce(:+)
    end

    def next_step_for(intro, step)
      next_estimate_step(steps_list_for(intro).flatten, step)
    end

    def previous_step_for(estimate, step)
      next_estimate_step(steps_list_for(estimate).flatten.reverse, step)
    end

    def last_step_in_group?(model, step)
      steps_list = steps_list_for(model).detect { |list| list.include?(step) }
      step == steps_list.last
    end

    def valid_step?(model, step)
      steps_list_for(model).flatten.include?(step)
    end

  private

    def steps_list_for(estimate)
      all_sections.map { |section| section.steps_for(estimate) }.reduce(:+)
    end

    def all_sections
      [ApplicantCaseDetailsSection, IncomeSection, CapitalSection]
    end

    def next_estimate_step(steps, step)
      steps.each_cons(2).detect { |old, _new| old == step }&.last
    end
  end
end
