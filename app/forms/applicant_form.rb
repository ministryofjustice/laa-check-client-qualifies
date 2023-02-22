class ApplicantForm
  include ActiveModel::Model
  include ActiveModel::Attributes
  include SessionPersistable

  attr_accessor :level_of_help

  PROCEEDING_TYPES = { domestic_abuse: "DA001", other: "SE003" }.freeze

  PROCEEDING_ATTRIBUTE = %i[proceeding_type].freeze
  BOOLEAN_ATTRIBUTES = %i[over_60 employed partner passporting].freeze

  ATTRIBUTES = BOOLEAN_ATTRIBUTES + PROCEEDING_ATTRIBUTE.freeze

  attribute :proceeding_type
  validates :proceeding_type,
            presence: true,
            inclusion: { in: PROCEEDING_TYPES.values, allow_nil: true },
            if: -> { !FeatureFlags.enabled?(:controlled) && level_of_help != "controlled" }

  BOOLEAN_ATTRIBUTES.each do |attr|
    attribute attr, :boolean
    validates attr, inclusion: { in: [true, false] }
  end

  class << self
    def from_session(session_data)
      super(session_data).tap { set_level_of_help(_1, session_data) }
    end

    def from_params(params, session_data)
      super(params, session_data).tap { set_level_of_help(_1, session_data) }
    end

    def set_level_of_help(form, session_data)
      form.level_of_help = session_data["level_of_help"]
    end
  end
end
