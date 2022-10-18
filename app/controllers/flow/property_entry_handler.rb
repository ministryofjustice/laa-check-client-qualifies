module Flow
  class PropertyEntryHandler
    class << self
      def model(session_data, _index = 0)
        PropertyEntryForm.new(session_data.slice(*PropertyEntryForm::ENTRY_ATTRIBUTES.map(&:to_s))).tap do |model|
          model.property_owned = session_data["property_owned"]
        end
      end

      def form(params, session_data, _index)
        PropertyEntryForm.new(params.require(:property_entry_form).permit(*PropertyEntryForm::ENTRY_ATTRIBUTES)).tap do |model|
          model.property_owned = session_data["property_owned"]
        end
      end

      # we can't call CFE here, as we're going to call it later after
      # the assets screen has been filled in
      def save_data(cfe_connection, estimate_id, estimate, _session_data); end
    end
  end
end
