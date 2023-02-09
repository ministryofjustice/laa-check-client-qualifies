class MatterTypeForm
  include ActiveModel::Model
  include ActiveModel::Attributes
  include SessionPersistable

  PROCEEDING_TYPES = { immigration: "IM030", asylum: "IA031" }.freeze

  ATTRIBUTES = %i[upper_tribunal_proceeding_type].freeze

  attribute :upper_tribunal_proceeding_type
  validates :upper_tribunal_proceeding_type,
            presence: true,
            inclusion: { in: PROCEEDING_TYPES.values, allow_nil: true }
end
