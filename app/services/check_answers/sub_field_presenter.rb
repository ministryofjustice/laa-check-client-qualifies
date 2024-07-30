# frozen_string_literal: true

module CheckAnswers
  class SubFieldPresenter
    attr_reader :type, :index

    def initialize(table_label:, attribute:, type:, model:, index:)
      @table_label = table_label
      @attribute = attribute
      @type = type
      @model = model
      @index = index
    end

    def screen
      nil
    end

    def disputed?
      nil
    end

    def value
      @model.public_send(@attribute)
    end

    def label
      "#{@table_label}_fields.#{@attribute}"
    end
  end
end
