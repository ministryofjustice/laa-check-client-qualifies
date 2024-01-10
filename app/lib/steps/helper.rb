module Steps
  class Helper
    class << self
      # This is only used in a test
      def all_possible_steps
        all_sections.map(&:all_steps).reduce(:+).uniq
      end

      def last_step_with_valid_data(session_data)
        # take all the possible steps for the data and check they are valid
        steps_list_for(session_data)
                     .take_while { |thestep|
                       Flow::Handler.model_from_session(thestep, session_data).valid?
                     }.last
      end

      def next_step_for(session_data, step)
        remaining_steps_for(session_data, step).first
      end

      def remaining_steps_for(session_data, step)
        # remaining steps is all of the upcoming steps i.e. the future steps in the journey
        remaining_steps(steps_list_for(session_data), step)
      end

      def previous_step_for(session_data, step)
        next_step(steps_list_for(session_data).reverse, step)
      end

      # all previous steps and this one
      def completed_steps_for(session_data, step)
        previous_steps(steps_list_for(session_data), step) + [step]
      end

      def last_step_in_group?(session_data, step)
        step_group = step_groups_for(session_data).detect { |group| group.steps.include?(step) }
        step == step_group.steps.last
      end

      def valid_step?(session_data, step)
        steps_list_for(session_data).include?(step.to_sym)
      end

      def first_step(session_data)
        steps_list_for(session_data).first
      end

      def last_step(session_data)
        steps_list_for(session_data || {}).last
      end

      # If you are working with the data you should call
      # this method to filter what is valid.
      def relevant_steps(session_data)
        steps_list_for(session_data).select do |step|
          Flow::Handler.model_from_session(step, session_data).valid?
        end
      end

      def last_step_for_section(session_data, section)
        step_groups = all_sections(session_data).find { |s| s.name.demodulize == (section.to_s.camelcase) }.grouped_steps_for(session_data)
        # if step_groups.any?
        #   step_groups.last.steps&.last
        step_groups.last.steps.last
        # end
      end

      def steps_for_section(session_data, section)
        section.grouped_steps_for(session_data).map(&:steps).reduce([], :+)
      end

      private

      def steps_list_for(session_data)
        step_groups_for(session_data).map(&:steps).flatten
      end

      def step_groups_for(session_data)
        all_sections(session_data).map { |section| section.grouped_steps_for(session_data) }.reduce(:+)
      end

      def all_sections(session_data = nil)
        initial_sections = [CaseDetailsSection,
                            ApplicantDetailsSection,
                            IncomeSection,
                            PartnerSection,
                            OutgoingsSection]

        if FeatureFlags.enabled?(:outgoings_flow, session_data, without_session_data: session_data.nil?)
          initial_sections + [PropertySection, AssetsAndVehiclesSection]
        else
          initial_sections + [AssetsAndVehiclesSection, PropertySection]
        end
      end

      def remaining_steps(steps, step)
        steps.each_cons(2).drop_while { |old, _new| old != step }.map(&:last)
      end

      def previous_steps(steps, step)
        steps.take_while { _1 != step }
      end

      def next_step(steps, step)
        steps.each_cons(2).detect { |old, _new| old == step }&.last
      end
    end
  end
end
