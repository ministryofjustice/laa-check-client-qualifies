class AssetsForm
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :assets, array: true, default: []
  validates :assets, at_least_one_item: true

  ASSETS_DECIMAL_ATTRIBUTES = %i[savings investments].freeze
  ASSETS_PROPERTY_ATTRIBUTES = %i[property_value property_mortgage].freeze
  ASSETS_ATTRIBUTES = (ASSETS_DECIMAL_ATTRIBUTES + ASSETS_PROPERTY_ATTRIBUTES + [:property_percentage_owned]).freeze

  ASSETS_DECIMAL_ATTRIBUTES.each do |asset_type|
    attribute asset_type, :decimal
    validates asset_type, numericality: { greater_than: 0 }, if: -> { assets.include?(asset_type.to_s) }
  end

  ASSETS_PROPERTY_ATTRIBUTES.each do |asset_type|
    attribute asset_type, :decimal
    validates asset_type, numericality: { greater_than: 0 }, if: -> { assets.include?("property") }
  end

  attribute :property_percentage_owned, :integer
  validates :property_percentage_owned,
            numericality: { greater_than: 0, only_integer: true, less_than_or_equal_to: 100, allow_nil: true },
            presence: true, if: -> { assets.include?("property") }
end
