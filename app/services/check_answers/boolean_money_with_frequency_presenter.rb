# frozen_string_literal: true

module CheckAnswers
  class BooleanMoneyWithFrequencyPresenter < FieldPresenter
    def initialize(table_label:, attribute:, model:, alt_attribute:, second_alt_attribute:)
      super(table_label:, attribute:, type: :boolean_money_with_frequency, screen: nil, model:)
      @alt_attribute = alt_attribute
      @second_alt_attribute = second_alt_attribute
    end

    def alt_value
      @model.public_send(@alt_attribute)
    end

    def second_alt_value
      @model.public_send(@second_alt_attribute)
    end
  end
end
