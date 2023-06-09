class MatterTypeForm
  include ActiveModel::Model
  include ActiveModel::Attributes
  include SessionPersistable

  MATTER_TYPES = %w[immigration asylum other domestic_abuse].freeze

  ATTRIBUTES = %i[matter_type].freeze

  attribute :matter_type
  validates :matter_type, presence: true, inclusion: { in: MATTER_TYPES, allow_nil: true }
end
