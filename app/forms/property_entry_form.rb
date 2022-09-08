class PropertyEntryForm
  include ActiveModel::Model
  include ActiveModel::Attributes

  ENTRY_ATTRIBUTES = %i[house_value mortgage percentage_owned].freeze

  attribute :house_value, :integer
  validates :house_value, numericality: { greater_than: 0, only_integer: true, allow_nil: true }, presence: true

  attribute :mortgage, :integer
  validates :mortgage, numericality: { greater_than: 0, only_integer: true, allow_nil: true }, presence: true

  attribute :percentage_owned, :integer
  validates :percentage_owned, numericality: { greater_than: 0, only_integer: true, less_than_or_equal_to: 100, allow_nil: true }, presence: true
end
