module Flow
  class PropertyEntryHandler
    class << self
      def model(session_data)
        PropertyEntryForm.new(session_data.slice(*PropertyEntryForm::ENTRY_ATTRIBUTES.map(&:to_s))).tap do |model|
          model.property_owned = session_data["property_owned"]
        end
      end

      def form(params, session_data)
        PropertyEntryForm.new(params.require(:property_entry_form).permit(*PropertyEntryForm::ENTRY_ATTRIBUTES)).tap do |model|
          model.property_owned = session_data["property_owned"]
        end
      end

      def save_data(cfe_connection, estimate_id, model, session_data)
        main_home = {
          value: model.house_value,
          outstanding_mortgage: (model.mortgage.presence if session_data["property_owned"] == "with_mortgage") || 0,
          percentage_owned: model.percentage_owned,
        }
        cfe_connection.create_properties(estimate_id, main_home, nil)
      end
    end
  end
end
