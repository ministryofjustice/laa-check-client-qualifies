# frozen_string_literal: true

module CheckAnswers
  class MoneyWithFrequencyPresenter < FieldPresenter
    attr_reader :frequency_value

    def initialize(table_label:, attribute:, model:, frequency_value:)
      super(table_label:, attribute:, type: :money_with_frequency, model:)
      @frequency_value = frequency_value
    end
  end
end
