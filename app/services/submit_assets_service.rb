class SubmitAssetsService < BaseCfeService
  def self.call(cfe_estimate_id, cfe_session_data)
    new.call(cfe_estimate_id, cfe_session_data)
  end

  def call(cfe_estimate_id, cfe_session_data)
    asset_form = Flow::AssetHandler.model(cfe_session_data)
    liquid_assets = { savings: asset_form.savings }.select { |_asset, value| value.positive? }.map(&:last)
    illiquid_assets = {
      investments: asset_form.investments,
      valuables: asset_form.valuables,
    }.select { |_asset, value| value.positive? }.map(&:last)
    cfe_connection.create_capitals cfe_estimate_id, liquid_assets, illiquid_assets if liquid_assets.any? || illiquid_assets.any?

    if asset_form.property_value.positive?
      second_property = {
        value: asset_form.property_value,
        outstanding_mortgage: asset_form.property_mortgage,
        percentage_owned: asset_form.property_percentage_owned,
      }
    end
    property_form = Flow::PropertyHandler.model(cfe_session_data)
    if property_form.owned?
      property_entry_form = Flow::PropertyEntryHandler.model(cfe_session_data)
      main_home = {
        value: property_entry_form.house_value,
        outstanding_mortgage: (property_entry_form.mortgage if property_form.owned_with_mortgage?) || 0,
        percentage_owned: property_entry_form.percentage_owned,
      }
    end

    cfe_connection.create_properties(cfe_estimate_id, main_home, second_property) if main_home.present? || second_property.present?
  end
end
