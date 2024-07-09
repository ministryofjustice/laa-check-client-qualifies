# frozen_string_literal: true

module CheckAnswers
  class OptionalMoneyPresenter < FieldPresenter
    def initialize(table_label:, attribute:, model:, relevancy_attribute:)
      super(table_label:, attribute:, type: :optional_money, screen: nil, model:)
      @relevancy_attribute = relevancy_attribute
    end

    def disputed?
      false
    end

    def relevancy_value
      @model.public_send(@relevancy_attribute)
    end
  end
end
