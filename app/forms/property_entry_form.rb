class PropertyEntryForm
  include ActiveModel::Model
  include ActiveModel::Attributes

  ENTRY_ATTRIBUTES = %i[house_value mortgage percentage_owned].freeze

  attr_accessor :property_owned

  attribute :house_value, :gbp
  validates :house_value, numericality: { greater_than: 0, allow_nil: true }, presence: true

  attribute :mortgage, :gbp
  validates :mortgage,
            numericality: { greater_than: 0, allow_nil: true },
            presence: { if: -> { property_owned == "with_mortgage" } }

  attribute :percentage_owned, :integer
  validates :percentage_owned,
            numericality: { greater_than: 0, only_integer: true, less_than_or_equal_to: 100, allow_nil: true, message: :within_range },
            presence: true
end
