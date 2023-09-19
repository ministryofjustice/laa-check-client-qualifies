# This file uses the rules defined by an array of "mappings" to generate a hash with
# values derived from the session_data passed in.

# For the most part it does this by calling methods on a ControlledWorkDocumentContent
# model.

# The mappings have the following attributes:
# name - the name of a field in the PDF, which should be a key of the output hash
# type - what sort of field this is (either `text`,  `always_checked_checkbox` or `boolean_radio` (i.e. "Yes" and "No" radio buttons))
# source - where to get the value from - either an attribute on a form or via method in ControlledWorkDocumentContent
# section - which part of the form is the field in (which determines when it should be skipped)
# checked_value - if `type` is `checkbox` this is the value that the field must be set to in order to mark it as checked
# yes_value - if `type` is `boolean_radio` this is the value that the field must be set to in order to mark "Yes" as selected
# no_value - if `type` is `boolean_radio` this is the value that the field must be set to in order to mark "No" as selected
class ControlledWorkDocumentValueMappingService
  class << self
    include ActionView::Helpers::NumberHelper

    def call(session_data, mappings)
      content = ControlledWorkDocumentContent.new(session_data)
      mappings.map { [_1[:name], convert(_1, content)] }.to_h
    end

  private

    def convert(mapping, content)
      case mapping[:type]
      when "always_checked_checkbox"
        mapping[:checked_value]
      when "boolean_radio"
        return if skip?(mapping[:section], content)

        case value(mapping, content)
        when true
          mapping[:yes_value]
        when false
          mapping[:no_value]
        end
      when "text"
        return if skip?(mapping[:section], content)

        format(value(mapping, content))
      else
        raise "Unknown mapping type #{mapping[:type]} for mapping #{mapping[:name]}"
      end
    end

    def value(mapping, content)
      content.send(mapping[:source])
    end

    def skip?(section, content)
      return false unless section

      case section
      when "smod_capital"
        !content.smod_assets?
      when "capital"
        !content.client_capital_relevant?
      when "partner_capital"
        !content.partner_capital_relevant?
      when "income"
        !content.client_income_relevant?
      when "partner_income"
        !content.partner_income_relevant?
      else
        raise "Unknown section '#{section}'"
      end
    end

    def format(value)
      # Unless a section is skipped (see above), we want to fill in
      # a value for every section, defaulting to "0"
      return "0" unless value
      return value unless value.is_a?(Numeric)

      precision = value.round == value ? 0 : 2

      number_with_precision(value, precision:, delimiter: ",")
    end
  end
end
