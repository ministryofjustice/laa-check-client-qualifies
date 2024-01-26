module Steps
  class GrossIncomeIneligibleSection
    class << self
      def all_steps
        %i[ineligible_gross_income]
      end

      def grouped_steps_for(session_data)
        if Steps::Logic.gross_ineligible?(session_data)
          [Steps::Group.new(*all_steps)]
        else
          []
        end
      end
    end
  end
end
