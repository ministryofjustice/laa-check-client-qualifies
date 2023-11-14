module Steps
  class OutgoingsSection
    class << self
      def all_steps
        %i[outgoings partner_outgoings]
      end

      def grouped_steps_for(session_data)
        if !Steps::Logic.show_outgoings_sections?(session_data)
          []
        elsif Steps::Logic.partner?(session_data)
          [Steps::Group.new(:outgoings),
           Steps::Group.new(:partner_outgoings)].compact
        else
          [Steps::Group.new(:outgoings)]
        end
      end
    end
  end
end
