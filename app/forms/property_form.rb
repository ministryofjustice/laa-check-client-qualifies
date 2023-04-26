class PropertyForm
  include ActiveModel::Model
  include ActiveModel::Attributes
  include SessionPersistable

  ATTRIBUTES = %i[property_owned].freeze

  OWNED_OPTIONS = %i[outright with_mortgage].freeze
  OPTIONS = (OWNED_OPTIONS + %i[none]).freeze

  attribute :property_owned, :string
  validates :property_owned, inclusion: { in: OPTIONS.map(&:to_s), allow_nil: false }

  def owned_with_mortgage?
    property_owned == "with_mortgage"
  end
end
