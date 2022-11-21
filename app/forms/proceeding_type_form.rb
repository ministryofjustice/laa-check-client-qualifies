class ProceedingTypeForm
  include ActiveModel::Model
  include ActiveModel::Attributes
  include SessionPersistable

  PROCEEDING_TYPES = { domestic_abuse: "DA001", other: "SE003" }.freeze

  ATTRIBUTES = [:proceeding_type].freeze

  attribute :proceeding_type
  validates :proceeding_type, presence: true, inclusion: { in: PROCEEDING_TYPES.values, allow_nil: true }
end
