module Flow
  class PropertyEntryHandler
    class << self
      PROPERTY_ATTRIBUTES = (PropertyEntryForm::ENTRY_ATTRIBUTES + [:house_in_dispute]).freeze

      def model(session_data)
        PropertyEntryForm.new(session_data.slice(*PROPERTY_ATTRIBUTES.map(&:to_s))).tap do |model|
          model.property_owned = session_data["property_owned"]
        end
      end

      def form(params, session_data)
        PropertyEntryForm.new(params.require(:property_entry_form).permit(*PropertyEntryForm::ENTRY_ATTRIBUTES, house_in_dispute: [])).tap do |model|
          model.property_owned = session_data["property_owned"]
        end
      end
    end
  end
end
