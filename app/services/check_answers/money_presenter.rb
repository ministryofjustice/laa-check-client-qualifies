# frozen_string_literal: true

module CheckAnswers
  class MoneyPresenter < FieldPresenter
    def initialize(table_label:, attribute:, model:, disputed: false)
      super(table_label:, attribute:, type: :money, screen: nil, model:)
      @disputed = disputed
    end

    # top level field so never has an index
    def index
      nil
    end

    def disputed?
      @disputed
    end
  end
end
