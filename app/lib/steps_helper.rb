class StepsHelper
  ALL_SECTIONS = [ApplicantCaseDetailsSection, IncomeSection, CapitalSection].freeze

  class << self
    def all_possible_steps
      ALL_SECTIONS.map(&:all_steps).reduce { |l, t| l + t }
    end

    def next_step_for(model, step)
      case step
      when :edit_benefit
        :benefits_more
      when :benefit_remove
        :benefits_more
      else
        next_estimate_step(steps_list_for(model).flatten, step)
      end
    end

    def previous_step_for(estimate, step)
      next_estimate_step(steps_list_for(estimate).flatten.reverse, step)
    end

    def step_should_save?(model, step)
      section_for(step).step_should_save?(model, step)
    end

    def valid_step?(model, step)
      steps_list_for(model).flatten.include?(step)
    end

  private

    def section_for(step)
      ALL_SECTIONS.detect { |section| section.all_steps.include?(step) }
    end

    def steps_list_for(estimate)
      ALL_SECTIONS.map { |section| section.steps_for(estimate) }.reduce { |l, t| l + t }
    end

    def next_estimate_step(steps, step)
      steps.each_cons(2).detect { |old, _new| old == step }&.last
    end
  end
end
