# frozen_string_literal: true

module CheckAnswers
  class BooleanMoneyPresenter < FieldPresenter
    def initialize(table_label:, attribute:, model:, alt_attribute:)
      super(table_label:, attribute:, type: :boolean_money, screen: nil, model:)
      @alt_attribute = alt_attribute
    end

    def disputed?
      false
    end

    def alt_value
      @model.public_send(@alt_attribute)
    end
  end
end
