class BaseAssetsForm
  include ActiveModel::Model
  include ActiveModel::Attributes
  include SessionPersistable

  ASSETS_DECIMAL_ATTRIBUTES = %i[savings investments valuables].freeze
  ASSETS_PROPERTY_ATTRIBUTES = %i[property_value property_mortgage].freeze
  BASE_ATTRIBUTES = (ASSETS_DECIMAL_ATTRIBUTES + ASSETS_PROPERTY_ATTRIBUTES + [:property_percentage_owned]).freeze

  attribute :property_value, :gbp
  validates :property_value, numericality: { greater_than_or_equal_to: 0, allow_nil: true }, presence: true

  attribute :property_mortgage, :gbp
  validates :property_mortgage, numericality: { greater_than_or_equal_to: 0, allow_nil: true }, presence: true,
                                if: -> { property_value.to_i.positive? }

  attribute :property_percentage_owned, :fully_validatable_integer
  validates :property_percentage_owned,
            numericality: { greater_than: 0, only_integer: true, less_than_or_equal_to: 100, allow_nil: true },
            presence: true, if: -> { property_value.to_i.positive? }

  ASSETS_DECIMAL_ATTRIBUTES.each do |asset_type|
    attribute asset_type, :gbp
    validates asset_type, numericality: { allow_nil: true }, presence: true
  end

  validate :positive_valuables_must_be_over_500

  def positive_valuables_must_be_over_500
    return if valuables.to_i.zero? || valuables >= 500

    errors.add(:valuables, :below_500)
  end
end
