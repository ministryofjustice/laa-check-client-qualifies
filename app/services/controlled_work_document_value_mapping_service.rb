# This file uses the rules defined by an array of "mappings" to generate a hash with
# values derived from the session_data passed in.

# For the most part it does this by calling methods on a ControlledWorkDocumentContent
# model.

# The mappings have the following attributes:
# name - the name of a field in the PDF, which should be a key of the output hash
# type - what sort of field this is (either `text`,  `checkbox` or `boolean_radio` (i.e. "Yes" and "No" radio buttons))
# source - where to get the value from - either an attribute on a form or via method in ControlledWorkDocumentContent
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
        case value(mapping, content)
        when true
          mapping[:yes_value]
        when false
          mapping[:no_value]
        end
      when "text"
        format(value(mapping, content))
      else
        raise "Unknown mapping type #{mapping[:type]} for mapping #{mapping[:name]}"
      end
    end

    def value(mapping, content)
      content.send(mapping[:source])
    end

    def format(value)
      return unless value
      return value unless value.is_a?(Numeric)

      non_negative_value = [value, 0].max

      precision = non_negative_value.round == non_negative_value ? 0 : 2

      number_with_precision(non_negative_value, precision:, delimiter: ",")
    end
  end
end
