# frozen_string_literal: true

module CheckAnswers
  class MoneySubFieldPresenter < SubFieldPresenter
    def initialize(table_label:, attribute:, model:, index:, disputed:)
      super(table_label:, attribute:, type: :money, index: index, model:)
      @disputed = disputed
    end

    def disputed?
      @disputed
    end
  end
end
