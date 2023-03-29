class StepsHelper
  class << self
    def all_possible_steps
      all_sections.map(&:all_steps).reduce(:+)
    end

    def next_step_for(session_data, step)
      remaining_steps_for(session_data, step).first
    end

    def remaining_steps_for(session_data, step)
      remaining_steps(steps_list_for(session_data).flatten, step)
    end

    def previous_step_for(session_data, step)
      next_step(steps_list_for(session_data).flatten.reverse, step)
    end

    def last_step_in_group?(session_data, step)
      steps_list = steps_list_for(session_data).detect { |list| list.include?(step) }
      step == steps_list.last
    end

    def valid_step?(session_data, step)
      steps_list_for(session_data).flatten.include?(step)
    end

    def first_step
      steps_list_for({}).flatten.first
    end

  private

    def steps_list_for(session_data)
      all_sections.map { |section| section.steps_for(session_data) }.reduce(:+)
    end

    def all_sections
      [CaseDetailsSection, ApplicantDetailsSection, IncomeSection, CapitalSection, PartnerSection, PartnerIncomeSection, PartnerCapitalSection]
    end

    def remaining_steps(steps, step)
      steps.each_cons(2).drop_while { |old, _new| old != step }.map(&:last)
    end

    def next_step(steps, step)
      steps.each_cons(2).detect { |old, _new| old == step }&.last
    end
  end
end
