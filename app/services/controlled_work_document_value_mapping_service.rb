# This file uses the rules defined by an array of "mappings" to generate a hash with
# values derived from the session_data passed in.

# For the most part it does this by calling methods on a ControlledWorkDocumentContent
# model.

# The mappings have the following attributes:
# name - the name of a field in the PDF, which should be a key of the output hash
# type - what sort of field this is (either `text`,  `checkbox` or `boolean_radio` (i.e. "Yes" and "No" radio buttons))
# source - where to get the value from (either `from_attribute` or `from_cfe_payload`)
# attribute - if `source` is `from_attribute` then the attribute on the model object that contains the value to include.
# modifier - optional modifier to be used with methods in content model to return relevant data, such as if a property is non_smod
# cfe_payload_location - if `source` is `from_cfe_payload` then this is the dot-separated path to the relevant value in the CFE payload
# checked_value - if `type` is `checkbox` this is the value that the field must be set to in order to mark it as checked
# yes_value - if `type` is `boolean_radio` this is the value that the field must be set to in order to mark "Yes" as selected
# no_value - if `type` is `boolean_radio` this is the value that the field must be set to in order to mark "No" as selected
class ControlledWorkDocumentValueMappingService
  class << self
    def call(session_data, mappings)
      content = ControlledWorkDocumentContent.new(session_data)
      mappings.reject { skip?(_1, content) }.map { [_1[:name], convert(_1, content)] }.to_h
    end

    def skip?(mapping, content)
      (mapping[:skip_unless] && !content.send(mapping[:skip_unless])) || (mapping[:skip_if] && content.send(mapping[:skip_if]))
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
      case mapping[:source]
      when "from_attribute"
        content.from_attribute(mapping[:attribute], mapping[:modifier])
      when "from_cfe_payload"
        content.from_cfe_payload(mapping[:cfe_payload_location])
      else
        raise "Unknown mapping value type #{mapping[:source]} for mapping #{mapping[:name]}"
      end
    end
  end
end
