module Flow
  class PropertyEntryHandler
    class << self
      def model(session_data)
        PropertyEntryForm.new session_data.slice(*PropertyEntryForm::ENTRY_ATTRIBUTES)
      end

      def form(params)
        PropertyEntryForm.new(params.require(:property_entry_form).permit(*PropertyEntryForm::ENTRY_ATTRIBUTES))
      end

      def save_data(cfe_connection, estimate_id, estimate, _other)
        cfe_connection.create_main_property estimate_id,
                                            house_value: estimate.house_value,
                                            mortgage: estimate.mortgage,
                                            percentage_owned: estimate.percentage_owned
      end
    end
  end
end
