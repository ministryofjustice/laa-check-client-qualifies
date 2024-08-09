# frozen_string_literal: true

module CheckAnswers
  class MoneyWithFrequencyPresenter < FieldPresenter
    def initialize(table_label:, attribute:, model:, frequency_attribute:)
      super(table_label:, attribute:, type: :money_with_frequency, screen: nil, model:)
      @frequency_attribute = frequency_attribute
    end

    def frequency_value
      @model.public_send(@frequency_attribute)
    end
  end
end
