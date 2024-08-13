# frozen_string_literal: true

module CheckAnswers
  module Sections
    class Outgoings < Base
      def initialize(check)
        super(check:, label: :outgoings)
      end

      def subsections
        [
          Subsection.new(tables: OutgoingsSubsection.tables(check: @check, label: :outgoings, attribute_prefix: "")),
          if @check.partner
            Subsection.new(tables: OutgoingsSubsection.tables(check: @check, label: :partner_outgoings, attribute_prefix: "partner_"))
          end,
        ].compact
      end
    end
  end
end
