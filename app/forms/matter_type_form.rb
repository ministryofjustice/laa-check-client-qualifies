class MatterTypeForm
  include ActiveModel::Model
  include ActiveModel::Attributes
  include SessionPersistable

  PROCEEDING_TYPES = { immigration: "IM030", asylum: "IA031", other: "SE003", domestic_abuse: "DA001" }.freeze

  ATTRIBUTES = %i[proceeding_type].freeze

  attribute :proceeding_type
  validates :proceeding_type, presence: true

  validate :proceeding_type_valid?

  def proceeding_type_valid?
    valid = if check.controlled?
              proceeding_type.in?(PROCEEDING_TYPES.slice(:immigration, :asylum, :other).values)
            else
              proceeding_type.in?(PROCEEDING_TYPES.values)
            end
    errors.add(:proceeding_type, :blank) unless valid
  end
end
