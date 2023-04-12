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
      when "attribute"
        content.send(mapping[:attribute])
      when "money_from_cfe_payload"
        content.money_from_cfe_payload(mapping[:cfe_payload_location])
      when "money_attribute"
        content.money_attribute(mapping[:attribute])
      else
        raise "Unknown mapping value type #{mapping[:value_type]} for mapping #{mapping[:name]}"
      end
    end
  end
end
