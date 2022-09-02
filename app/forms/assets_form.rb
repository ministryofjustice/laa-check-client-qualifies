class AssetsForm
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :assets, array: true, default: []

  # If the 'exclusive' option is picked, then no items are sent
  # otherwise we should get at least 2 (a blank plus at least one selected)
  validates_each :assets do |record, attr, value|
    record.errors.add(attr, I18n.t("errors.at_least_one_checkbox")) if value.size == 1
  end

  ASSETS_ATTRIBUTES = [:savings].freeze

  ASSETS_ATTRIBUTES.each do |asset_type|
    attribute asset_type, :decimal
    validates asset_type, numericality: {greater_than: 0}, if: -> { assets.include?(asset_type.to_s) }
  end
end
