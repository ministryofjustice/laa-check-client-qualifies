# This file uses the rules defined by an array of "mappings" to generate a hash with
# values derived from the session_data passed in.

# For the most part it does this by calling methods on a ControlledWorkDocumentContent
# model.

# The mappings have the following attributes:
# name - the name of a field in the PDF, which should be a key of the output hash
# type - what sort of field this is (either `text`,  `checkbox` or `boolean_radio` (i.e. "Yes" and "No" radio buttons))
# value_type - where to get the value from (either `from_attribute` or `from_cfe_payload`)
# attribute - if `value_type` is `from_attribute` then the attribute on the model object that contains the value to include.
# cfe_payload_location - if `value_type` is `from_cfe_payload` then this is the dot-separated path to the relevant value in the CFE payload
# checked_value - if `type` is `checkbox` this is the value to indicate that it is checked
# yes_value - if `type` is `boolean_radio` this is the value to indicate that 'Yes' is selected
# no_value - if `type` is `boolean_radio` this is the value to indicate that 'No' is selected
class ControlledWorkDocumentValueMappingService
  class << self
    def call(session_data, mappings)
      content = ControlledWorkDocumentContent.new(session_data)
      mappings.map { [_1[:name], convert(_1, content)] }.to_h
    end

    def convert(mapping, content)
      case mapping[:type]
      when "checkbox"
        mapping[:checked_value] if value(mapping, content)
      when "boolean_radio"
        value(mapping, content) ? mapping[:yes_value] : mapping[:no_value]
      when "text"
        value(mapping, content)
      else
        raise "Unknown mapping type #{mapping[:type]} for mapping #{mapping[:name]}"
      end
    end

    def value(mapping, content)
      return if mapping[:skip_unless] && !content.send(mapping[:skip_unless])
      return if mapping[:skip_if] && content.send(mapping[:skip_if])

      case mapping[:value_type]
      when "from_attribute"
        content.from_attribute(mapping[:attribute])
      when "from_cfe_payload"
        content.from_cfe_payload(mapping[:cfe_payload_location])
      else
        raise "Unknown mapping value type #{mapping[:value_type]} for mapping #{mapping[:name]}"
      end
    end
  end
end
