module Flow
  class PropertyEntryHandler
    class << self
      def model(session_data)
        PropertyEntryForm.new session_data.slice(*PropertyEntryForm::ENTRY_ATTRIBUTES.map(&:to_s))
      end

      def form(params)
        PropertyEntryForm.new(params.require(:property_entry_form).permit(*PropertyEntryForm::ENTRY_ATTRIBUTES))
      end

      def save_data(cfe_connection, estimate_id, estimate, _session_data)
        main_home = {
          value: estimate.house_value,
          outstanding_mortgage: estimate.mortgage,
          percentage_owned: estimate.percentage_owned,
        }
        cfe_connection.create_properties(estimate_id, main_home, nil)
      end
    end
  end
end
