# frozen_string_literal: true

module CheckAnswers
  class OptionalMoneyWithFrequencyPresenter < FieldPresenter
    def initialize(table_label:, attribute:, model:, alt_attribute:, relevancy_attribute:)
      super(table_label:, attribute:, type: :optional_money_with_frequency, screen: nil, model:)
      @alt_attribute = alt_attribute
      @relevancy_attribute = relevancy_attribute
    end

    def alt_value
      @model.public_send(@alt_attribute)
    end

    def relevancy_value
      @model.public_send(@relevancy_attribute)
    end
  end
end
