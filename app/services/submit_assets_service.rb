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
      second_property[:subject_matter_of_dispute] = true if asset_form.property_in_dispute?
    end
    property_form = Flow::PropertyHandler.model(cfe_session_data)
    if property_form.owned?
      property_entry_form = Flow::PropertyEntryHandler.model(cfe_session_data)
      main_home = {
        value: property_entry_form.house_value,
        outstanding_mortgage: (property_entry_form.mortgage if property_form.owned_with_mortgage?) || 0,
        percentage_owned: property_entry_form.percentage_owned,
      }
      main_home[:subject_matter_of_dispute] = true if property_entry_form.in_dispute?
    end

    create_properties(cfe_estimate_id, main_home, second_property) if main_home.present? || second_property.present?
  end

private

  def create_properties(assessment_id, main_property, second_property)
    main_home = main_property ||
      {
        value: 0,
        outstanding_mortgage: 0,
        percentage_owned: 0,
      }
    properties = { main_home: main_home.merge(shared_with_housing_assoc: false) }
    properties[:additional_properties] = [second_property.merge(shared_with_housing_assoc: false)] if second_property
    cfe_connection.create_properties(assessment_id, properties)
  end
end
