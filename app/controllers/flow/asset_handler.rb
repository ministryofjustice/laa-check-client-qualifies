module Flow
  class AssetHandler
    ASSETS_ATTRIBUTES = (AssetsForm::ASSETS_ATTRIBUTES + [:assets]).freeze

    class << self
      def model(session_data)
        AssetsForm.new session_data.slice(*ASSETS_ATTRIBUTES.map(&:to_s))
      end

      def form(params, _session_data)
        AssetsForm.new(params.require(:assets_form).permit(*AssetsForm::ASSETS_ATTRIBUTES, assets: []))
      end

      def save_data(cfe_connection, estimate_id, form, session_data)
        liquid_assets = { savings: form.savings }.select { |asset, _value| form.assets.include? asset.to_s }.map(&:last)
        illiquid_assets = {
          investments: form.investments,
          valuables: form.valuables,
        }.select { |asset, _value| form.assets.include? asset.to_s }.map(&:last)
        cfe_connection.create_capitals estimate_id, liquid_assets, illiquid_assets if liquid_assets.any? || illiquid_assets.any?

        if form.assets.include?("property")
          second_property = {
            value: form.property_value,
            outstanding_mortgage: form.property_mortgage,
            percentage_owned: form.property_percentage_owned,
          }
        end
        property_form = PropertyHandler.model(session_data)
        if property_form.owned?
          property_entry_form = PropertyEntryHandler.model(session_data)
          main_home = {
            value: property_entry_form.house_value,
            outstanding_mortgage: (property_entry_form.mortgage if property_form.owned_with_mortgage?) || 0,
            percentage_owned: property_entry_form.percentage_owned,
          }
        end

        cfe_connection.create_properties(estimate_id, main_home, second_property) if main_home.present? || second_property.present?
      end
    end
  end
end
