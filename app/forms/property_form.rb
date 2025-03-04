class PropertyForm
  include ActiveModel::Model
  include ActiveModel::Attributes
  include SessionPersistable

  ATTRIBUTES = %i[property_owned].freeze

  OWNED_OPTIONS = %i[outright with_mortgage shared_ownership].freeze
  NON_OWNED_OPTIONS = %i[none].freeze
  def valid_options
    (OWNED_OPTIONS + NON_OWNED_OPTIONS).map(&:to_s)
  end

  attribute :property_owned, :string
  validates :property_owned, inclusion: { in: ->(form) { form.valid_options }, allow_nil: false }
end
