# frozen_string_literal: true

module CheckAnswers
  class OptionalMoneyPresenter < FieldPresenter
    attr_reader :relevancy_value

    def initialize(table_label:, attribute:, model:, relevancy_value:)
      super(table_label:, attribute:, type: :optional_money, model:)
      @relevancy_value = relevancy_value
    end

    def disputed?
      false
    end
  end
end
