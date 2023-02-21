class MatterTypeForm
  include ActiveModel::Model
  include ActiveModel::Attributes
  include SessionPersistable

  PROCEEDING_TYPES = { immigration: "IM030", asylum: "IA031", other: "SE003" }.freeze

  ATTRIBUTES = %i[controlled_proceeding_type].freeze

  attribute :controlled_proceeding_type
  validates :controlled_proceeding_type,
            presence: true,
            inclusion: { in: PROCEEDING_TYPES.values, allow_nil: true }
end
