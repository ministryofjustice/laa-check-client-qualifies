class PropertyForm
  include ActiveModel::Model
  include ActiveModel::Attributes
  include SessionPersistable

  ATTRIBUTES = %i[property_owned].freeze

  OWNED_OPTIONS = %i[outright with_mortgage shared_ownership].freeze
  NON_OWNED_OPTIONS = %i[none].freeze
  VALID_OPTIONS = (OWNED_OPTIONS + NON_OWNED_OPTIONS).freeze

  attribute :property_owned, :string
  validates :property_owned, inclusion: { in: VALID_OPTIONS.map(&:to_s), allow_nil: false }
end
