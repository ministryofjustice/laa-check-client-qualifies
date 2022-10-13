class AssetsForm
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :assets, array: true, default: []
  validates :assets, at_least_one_item: true

  ASSETS_DECIMAL_ATTRIBUTES = { savings: { greater_than: 0 },
                                investments: { greater_than: 0 },
                                valuables: { greater_than_or_equal_to: 500 } }.freeze
  ASSETS_PROPERTY_ATTRIBUTES = %i[property_value property_mortgage].freeze
  ASSETS_ATTRIBUTES = (ASSETS_DECIMAL_ATTRIBUTES.keys + ASSETS_PROPERTY_ATTRIBUTES + [:property_percentage_owned]).freeze

  ASSETS_DECIMAL_ATTRIBUTES.each do |asset_type, threshold|
    attribute asset_type, :gbp
    validates asset_type, numericality: threshold.merge(allow_nil: true), presence: true, if: -> { assets.include?(asset_type.to_s) }
  end

  attribute :property_value, :gbp
  attribute :property_mortgage, :gbp
  validates :property_value, numericality: { greater_than: 0, allow_nil: true }, presence: true, if: -> { assets.include?("property") }
  validates :property_mortgage, numericality: { greater_than_or_equal_to: 0, allow_nil: true }, presence: true, if: -> { assets.include?("property") }

  attribute :property_percentage_owned, :integer
  validates :property_percentage_owned,
            numericality: { greater_than: 0, only_integer: true, less_than_or_equal_to: 100, allow_nil: true },
            presence: true, if: -> { assets.include?("property") }
end
