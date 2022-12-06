class ApplicantForm
  include ActiveModel::Model
  include ActiveModel::Attributes
  include SessionPersistable

  PROCEEDING_TYPES = { domestic_abuse: "DA001", other: "SE003" }.freeze

  PROCEEDING_ATTRIBUTE = %i[proceeding_type].freeze
  BOOLEAN_ATTRIBUTES = %i[over_60 employed partner passporting].freeze

  ATTRIBUTES = BOOLEAN_ATTRIBUTES + PROCEEDING_ATTRIBUTE.freeze

  attribute :proceeding_type
  validates :proceeding_type, presence: true, inclusion: { in: PROCEEDING_TYPES.values, allow_nil: true }

  BOOLEAN_ATTRIBUTES.each do |attr|
    attribute attr, :boolean
    validates attr, inclusion: { in: [true, false] }, if: -> { Flipper.enabled?(:partner) || attr != :partner }
  end
end
