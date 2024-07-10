# frozen_string_literal: true

module CheckAnswers
  class FieldPresenter
    attr_reader :type, :screen

    def initialize(table_label:, attribute:, type:, model:, screen: nil, partner_dependant_wording: false)
      @table_label = table_label
      @attribute = attribute
      @type = type
      @model = model
      @partner_dependant_wording = partner_dependant_wording
      @screen = screen
    end

    def value
      @model.public_send(@attribute)
    end

    def label
      # This can be deleted w/o any tests failing, so we need more coverage around this area
      addendum = "_partner" if @model.partner && @partner_dependant_wording

      "#{@table_label}_fields.#{@attribute}#{addendum}"
    end
  end
end
