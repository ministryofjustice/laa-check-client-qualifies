class AssetsForm
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :assets, array: true, default: []
  validates :assets, at_least_one_item: true

  ASSETS_ATTRIBUTES = %i[savings investments].freeze

  ASSETS_ATTRIBUTES.each do |asset_type|
    attribute asset_type, :decimal
    validates asset_type, numericality: { greater_than: 0 }, if: -> { assets.include?(asset_type.to_s) }
  end
end
