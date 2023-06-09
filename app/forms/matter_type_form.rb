class MatterTypeForm
  include ActiveModel::Model
  include ActiveModel::Attributes
  include SessionPersistable

  MATTER_TYPES = %w[immigration asylum other domestic_abuse].freeze

  ATTRIBUTES = %i[matter_type].freeze

  attribute :matter_type
  validates :matter_type, presence: true

  validate :matter_type_valid?

  def matter_type_valid?
    valid = if check.controlled?
              matter_type.in?(MATTER_TYPES - ["domestic_abuse"])
            else
              matter_type.in?(MATTER_TYPES)
            end
    errors.add(:matter_type, :blank) unless valid
  end
end
