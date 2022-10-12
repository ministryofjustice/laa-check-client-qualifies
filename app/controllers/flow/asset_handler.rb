module Flow
  class AssetHandler
    ASSETS_ATTRIBUTES = (AssetsForm::ASSETS_ATTRIBUTES + [:assets]).freeze

    class << self
      def model(session_data)
        # think of this as a load from session
        AssetsForm.new session_data.slice(*ASSETS_ATTRIBUTES)
      end

      def form(params, _session_data)
        # think of this as save/update the information
        AssetsForm.new(params.require(:assets_form).permit(*AssetsForm::ASSETS_ATTRIBUTES, assets: []))
      end

      # def save_data(cfe_connection, estimate_id, form, session_data)
      #   savings = [form.savings].compact
      #   investments = [form.investments].compact
      #   cfe_connection.create_capitals estimate_id, savings, investments
      #
      #   if form.assets.include?("property")
      #     property_entry_form = PropertyEntryHandler.model(session_data)
      #     main_home = {
      #       value: property_entry_form.house_value,
      #       outstanding_mortgage: property_entry_form.mortgage,
      #       percentage_owned: property_entry_form.percentage_owned,
      #     }
      #     second_property = {
      #       value: form.property_value,
      #       outstanding_mortgage: form.property_mortgage,
      #       percentage_owned: form.property_percentage_owned,
      #     }
      #     cfe_connection.create_properties(estimate_id, main_home, second_property)
      #   end
      # end
    end
  end
end
