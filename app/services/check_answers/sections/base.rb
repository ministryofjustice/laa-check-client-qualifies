# frozen_string_literal: true

module CheckAnswers
  module Sections
    class Base
      attr_reader :label

      def initialize(check:, label:)
        @check = check
        @label = label
      end
    end
  end
end
