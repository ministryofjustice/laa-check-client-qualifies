module Steps
  class Helper
    class << self
      # This is only used in a test
      def all_possible_steps
        all_sections.map(&:all_steps).reduce(:+).uniq
      end

      def next_step_for(session_data, step)
        remaining_steps_for(session_data, step).first
      end

      # upcoming steps i.e. future steps in journey
      def remaining_steps_for(session_data, step)
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
        steps_list_for(session_data)
      end

      def cannot_use_service?(session_data, step)
        cannot_use_service_main_property?(session_data, step) || cannot_use_service_additional_property?(session_data, step)
      end

      def cannot_use_service_additional_property?(session_data, step)
        additional_property_shared_ownership?(session_data, step) || partner_additional_property_shared_ownership?(session_data, step)
      end

    private

      def steps_list_for(session_data)
        step_groups_for(session_data).map(&:steps).flatten
      end

      def step_groups_for(session_data)
        all_sections.map { |section| section.grouped_steps_for(session_data) }.reduce(:+)
      end

      def all_sections
        [NonFinancialSection,
         IncomeSection,
         PartnerSection,
         OutgoingsSection,
         PropertySection,
         AssetsAndVehiclesSection]
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

      def additional_property_shared_ownership?(session_data, step)
        step == :additional_property && session_data["additional_property_owned"] == "shared_ownership"
      end

      def partner_additional_property_shared_ownership?(session_data, step)
        step == :partner_additional_property && session_data["partner_additional_property_owned"] == "shared_ownership"
      end

      def cannot_use_service_main_property?(session_data, step)
        step == :property_landlord && session_data["property_landlord"] == false
      end
    end
  end
end
