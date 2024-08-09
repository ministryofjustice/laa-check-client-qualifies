# frozen_string_literal: true

module CheckAnswers
  class MoneySubFieldPresenter < SubFieldPresenter
    attr_reader :index

    def initialize(table_label:, attribute:, model:, index:, disputed:)
      super(table_label:, attribute:, type: :money, model:)
      @disputed = disputed
      @index = index
    end

    def disputed?
      @disputed
    end
  end
end
