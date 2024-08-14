# frozen_string_literal: true

module CheckAnswers
  class OptionalMoneyWithFrequencyPresenter < FieldPresenter
    attr_reader :frequency_value, :relevancy_value

    def initialize(table_label:, attribute:, model:, frequency_value:, relevancy_value:)
      super(table_label:, attribute:, type: :optional_money_with_frequency, model:)
      @frequency_value = frequency_value
      @relevancy_value = relevancy_value
    end
  end
end
