# frozen_string_literal: true

module CheckAnswers
  class PartnerDependantFieldPresenter
    attr_reader :type

    def initialize(table_label:, attribute:, type:, model:)
      @table_label = table_label
      @attribute = attribute
      @type = type
      @model = model
    end

    def screen
      nil
    end

    def value
      @model.public_send(@attribute)
    end

    def label
      if @model.partner
        "#{@table_label}_fields.#{@attribute}_partner"
      else
        "#{@table_label}_fields.#{@attribute}"
      end
    end
  end
end
