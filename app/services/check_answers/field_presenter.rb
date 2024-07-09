# frozen_string_literal: true

module CheckAnswers
  class FieldPresenter
    attr_reader :type, :screen

    def initialize(table_label:, attribute:, type:, check:, screen:, partner_dependant_wording: false)
      @table_label = table_label
      @attribute = attribute
      @type = type
      @check = check
      @partner_dependant_wording = partner_dependant_wording
      @screen = screen
    end

    def value
      @check.public_send(@attribute)
    end

    def label
      # addendum = "_partner" if @check.partner && @partner_dependant_wording
      addendum = nil

      "#{@table_label}_fields.#{@attribute}#{addendum}"
    end
  end
end