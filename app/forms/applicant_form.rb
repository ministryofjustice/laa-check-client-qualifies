class ApplicantForm
  include ActiveModel::Model
  include ActiveModel::Attributes
  include SessionPersistable

  attr_accessor :level_of_help

  PROCEEDING_TYPES = { domestic_abuse: "DA001", other: "SE003" }.freeze
  EMPLOYED_STATUSES = %i[in_work receiving_statutory_pay].freeze
  EMPLOYMENT_STATUSES = (EMPLOYED_STATUSES + %i[unemployed]).freeze

  STRING_ATTRIBUTES = %i[legacy_proceeding_type employment_status].freeze
  BOOLEAN_ATTRIBUTES = %i[over_60 partner passporting].freeze

  ATTRIBUTES = (BOOLEAN_ATTRIBUTES + STRING_ATTRIBUTES).freeze

  attribute :legacy_proceeding_type
  validates :legacy_proceeding_type,
            presence: true,
            inclusion: { in: PROCEEDING_TYPES.values, allow_nil: true },
            if: -> { !FeatureFlags.enabled?(:asylum_and_immigration) && level_of_help != "controlled" }

  attribute :over_60, :boolean
  validates :over_60, inclusion: { in: [true, false] }

  attribute :employment_status, :string
  validates :employment_status,
            inclusion: { in: EMPLOYMENT_STATUSES.map(&:to_s), allow_nil: false }

  attribute :partner, :boolean
  validates :partner, inclusion: { in: [true, false] }

  attribute :passporting, :boolean
  validates :passporting, inclusion: { in: [true, false] }

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
