# frozen_string_literal: true

module CheckAnswers
  class MoneyWithFrequencyPresenter < FieldPresenter
    def initialize(table_label:, attribute:, model:, alt_attribute:)
      super(table_label:, attribute:, type: :money_with_frequency, screen: nil, model:)
      @alt_attribute = alt_attribute
    end

    def alt_value
      @model.public_send(@alt_attribute)
    end
  end
end
