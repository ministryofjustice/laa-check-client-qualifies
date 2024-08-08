# frozen_string_literal: true

module CheckAnswers
  class OptionalMoneyWithFrequencyPresenter < FieldPresenter
    def initialize(table_label:, attribute:, model:, frequency_attribute:, relevancy_attribute:)
      super(table_label:, attribute:, type: :optional_money_with_frequency, screen: nil, model:)
      @frequency_attribute = frequency_attribute
      @relevancy_attribute = relevancy_attribute
    end

    def frequency_value
      @model.public_send(@frequency_attribute)
    end

    def relevancy_value
      @model.public_send(@relevancy_attribute)
    end
  end
end
