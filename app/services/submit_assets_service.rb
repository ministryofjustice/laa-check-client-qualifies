class SubmitAssetsService < BaseCfeService
  Asset = Struct.new :amount, :disputed?, keyword_init: true

  def self.call(cfe_estimate_id, cfe_session_data)
    new.call(cfe_estimate_id, cfe_session_data)
  end

  def call(cfe_estimate_id, cfe_session_data)
    asset_form = ClientAssetsForm.from_session(cfe_session_data)

    liquid_assets = [
      Asset.new(amount: asset_form.savings, disputed?: asset_form.savings_in_dispute?),
    ].select { |value| value.amount.positive? }

    illiquid_assets = [
      Asset.new(amount: asset_form.investments, disputed?: asset_form.investments_in_dispute?),
      Asset.new(amount: asset_form.valuables, disputed?: asset_form.valuables_in_dispute?),
    ].select { |value| value.amount.positive? }

    create_capitals cfe_estimate_id, liquid_assets, illiquid_assets if liquid_assets.any? || illiquid_assets.any?

    if asset_form.property_value.positive?
      second_property = {
        value: asset_form.property_value,
        outstanding_mortgage: asset_form.property_mortgage,
        percentage_owned: asset_form.property_percentage_owned,
      }
      second_property[:subject_matter_of_dispute] = true if asset_form.property_in_dispute?
    end
    property_form = PropertyForm.from_session(cfe_session_data)
    if property_form.owned?
      property_entry_form = PropertyEntryForm.from_session(cfe_session_data)
      main_home = {
        value: property_entry_form.house_value,
        outstanding_mortgage: (property_entry_form.mortgage if property_form.owned_with_mortgage?) || 0,
        percentage_owned: property_entry_form.percentage_owned,
      }
      main_home[:subject_matter_of_dispute] = true if property_entry_form.house_in_dispute
    end

    create_properties(cfe_estimate_id, main_home, second_property) if main_home.present? || second_property.present?
  end

private

  class << self
    def asset_to_cfe(asset, description)
      {
        value: asset.amount,
        description:,
      }.tap do |account|
        account[:subject_matter_of_dispute] = true if asset.disputed?
      end
    end
  end

  def create_capitals(assessment_id, liquid_assets, illiquid_assets)
    # descriptions are mandatory in CFE
    bank_accounts = liquid_assets.map { |asset| self.class.asset_to_cfe(asset, "Liquid Asset") }
    non_liquid_capital = illiquid_assets.map { |asset| self.class.asset_to_cfe(asset, "Non Liquid Asset") }
    cfe_connection.create_capitals(assessment_id, bank_accounts, non_liquid_capital)
  end

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
