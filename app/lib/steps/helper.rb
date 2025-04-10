module Steps
  class Helper
    class << self
      # This is only used in a test
      def all_possible_steps
        all_sections.map(&:all_steps).reduce(:+).uniq
      end

      def last_step_with_valid_data(session_data)
        steps_list_for(session_data)
                     .take_while { |thestep|
                       Flow::Handler.model_from_session(thestep, session_data).valid?
                     }.last
      end

      def consistent?(session_data)
        steps_list_for(session_data)
          .reject { |thestep| Flow::Handler.model_from_session(thestep, session_data).valid? }
          .none?
      end

      # check consistency just for non-financial questions (asylum, under 18 etc)
      def non_financial_consistent?(session_data)
        non_finance_steps(session_data)
          .reject { |thestep| Flow::Handler.model_from_session(thestep, session_data).valid? }
          .none?
      end

      def non_finance_steps(session_data)
        steps_for_section(session_data, Steps::NonFinancialSection)
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

      def last_step_for_section(session_data, section)
        step_groups = all_sections.find { |s| s.name.demodulize == (section.to_s.camelcase) }.grouped_steps_for(session_data)
        step_groups.last.steps.last
      end

      def steps_for_section(session_data, section)
        section.grouped_steps_for(session_data).map(&:steps).reduce([], :+)
      end

      # If you are working with the data you should call
      # this method to filter what is valid.
      def relevant_steps(session_data)
        # if the list is *very* short (i.e. non-means) then use it rather then up to income
        if Steps::Logic.non_means_tested?(session_data)
          steps_list_for(session_data)
        elsif Steps::Logic.check_stops_at_gross_income?(session_data)
          completed_steps_for(session_data, :other_income)
        else
          steps_list_for(session_data)
        end
      end

      def cannot_use_service?(session_data, step)
        additional_property_shared_ownership?(session_data, step) || partner_additional_property_shared_ownership?(session_data, step)
      end

      def display_property_entry_in_change_answers?(session_data, step)
        passported_shared_ownership?(session_data, step) || non_passported_shared_ownership?(session_data, step)
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

      def passported_shared_ownership?(session_data, step)
        step == :property_landlord && !Steps::Logic.landlord_is_not_the_only_joint_owner?(session_data)
      end

      def non_passported_shared_ownership?(session_data, step)
        step == :shared_ownership_housing_costs && !Steps::Logic.landlord_is_not_the_only_joint_owner?(session_data)
      end
      def additional_property_shared_ownership?(session_data, step)
        step == :additional_property && session_data["additional_property_owned"] == "shared_ownership"
      end

      def partner_additional_property_shared_ownership?(session_data, step)
        step == :partner_additional_property && session_data["partner_additional_property_owned"] == "shared_ownership"
      end
    end
  end
end
