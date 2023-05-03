module Steps
  class Helper
    class << self
      def all_possible_steps
        all_sections.map(&:all_steps).reduce(:+)
      end

      def next_step_for(session_data, step)
        remaining_steps_for(session_data, step).first
      end

      def remaining_steps_for(session_data, step)
        remaining_steps(steps_list_for(session_data), step)
      end

      def previous_step_for(session_data, step)
        next_step(steps_list_for(session_data).reverse, step)
      end

      def last_step_in_group?(session_data, step)
        step_group = step_groups_for(session_data).detect { |group| group.steps.include?(step) }
        step == step_group.steps.last
      end

      def valid_step?(session_data, step)
        steps_list_for(session_data).include?(step)
      end

      def first_step
        steps_list_for({}).first
      end

    private

      def steps_list_for(session_data)
        step_groups_for(session_data).map(&:steps).flatten
      end

      def step_groups_for(session_data)
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
end
