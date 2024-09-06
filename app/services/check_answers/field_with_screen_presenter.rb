# frozen_string_literal: true

module CheckAnswers
  class FieldWithScreenPresenter < FieldPresenter
    attr_reader :screen

    def initialize(table_label:, attribute:, type:, model:, screen:)
      super(table_label:, attribute:, type:, model:)
      @screen = screen
    end
  end
end
