module Strategy
  # This will forward to the base strategy if it doesn't need to do anything
  class EarlyEligibilityStrategy
    def initialize strategy
      @base_strategy = strategy
    end

    def next_step session_data, step
      if step == :ineligible_gross_income
        if session_data["check_answers"] == "return"
          # TODO - this is too simple, need to work out which step responds to last_tag_in_group?(:gross_income)
          @base_strategy.next_step session_data, :other_income
        end
      else
          if last_tag_in_group?(session_data, step, :gross_income)
            gross_early_result = CfeService.cfe_result(CfeService.call(session_data, early_eligibility: :gross_income))
            # if gross_early_result == "ineligible" && session_data["check_answers"] != "return"
            if gross_early_result == "ineligible"
              return :ineligible_gross_income
            end
          end

          @base_strategy.next_step session_data, step
      end
    end

    private

    def tag_from(step)
      return if Flow::Handler::STEPS.fetch(step)[:tag].nil?

      Flow::Handler::STEPS.fetch(step)[:tag]
    end

    def last_tag_in_group?(session_data, step, tag)
      remaining_steps = Steps::Helper.remaining_steps_for(session_data, step)

      return if remaining_steps.blank?

      remaining_tags = []
      remaining_steps.map do |remaining|
        remaining_tags << tag_from(remaining)
      end
      return unless !remaining_tags.compact.include?(tag) && tag_from(step) == tag

      true
    end
  end
end
