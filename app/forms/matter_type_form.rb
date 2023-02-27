class MatterTypeForm
  include ActiveModel::Model
  include ActiveModel::Attributes
  include SessionPersistable

  PROCEEDING_TYPES = { immigration: "IM030", asylum: "IA031", other: "SE003", domestic_abuse: "DA001" }.freeze

  ATTRIBUTES = %i[proceeding_type].freeze

  attribute :proceeding_type
  validates :proceeding_type,
            presence: true,
            inclusion: { in: PROCEEDING_TYPES.values, allow_nil: true }
end
