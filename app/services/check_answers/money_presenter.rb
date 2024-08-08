# frozen_string_literal: true

module CheckAnswers
  class MoneyPresenter < FieldPresenter
    def initialize(table_label:, attribute:, model:)
      super(table_label:, attribute:, type: :money, screen: nil, model:)
    end

    def index
      nil
    end

    def disputed?
      false
    end
  end
end
