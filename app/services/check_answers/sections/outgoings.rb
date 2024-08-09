# frozen_string_literal: true

module CheckAnswers
  module Sections
    class Outgoings < Base
      def initialize(check)
        super(check:, label: :outgoings)
      end

      def subsections
        client_subsection = subsection_for(OutgoingsSubsection.tables(check: @check, label: :outgoings, attribute_prefix: ""))
        partner_subsection = if @check.partner
                               subsection_for(OutgoingsSubsection.tables(check: @check, label: :partner_outgoings, attribute_prefix: "partner_"))
                             end
        [
          client_subsection, partner_subsection
        ].compact
      end

    private

      def subsection_for(possible_tables)
        tables = possible_tables.select { Steps::Helper.relevant_steps(@check.session_data).include?(_1.screen) }
        Subsection.new(tables:) if tables.any?
      end
    end
  end
end
