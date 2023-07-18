class ApplicantForm
  include ActiveModel::Model
  include ActiveModel::Attributes
  include SessionPersistable

  delegate :session_data, to: :check

  EMPLOYED_STATUSES = %i[in_work receiving_statutory_pay].freeze
  EMPLOYMENT_STATUSES = (EMPLOYED_STATUSES + %i[unemployed]).freeze

  STRING_ATTRIBUTES = %i[employment_status].freeze
  BOOLEAN_ATTRIBUTES = %i[over_60 partner passporting].freeze

  ATTRIBUTES = (BOOLEAN_ATTRIBUTES + STRING_ATTRIBUTES).freeze

  attribute :over_60, :boolean
  validates :over_60, inclusion: { in: [true, false] }

  attribute :employment_status, :string
  validates :employment_status,
            inclusion: { in: EMPLOYMENT_STATUSES.map(&:to_s), allow_nil: false },
            if: -> { !FeatureFlags.enabled?(:self_employed, session_data) }

  attribute :partner, :boolean
  validates :partner, inclusion: { in: [true, false] }

  attribute :passporting, :boolean
  validates :passporting, inclusion: { in: [true, false] }

  def attributes_for_export_to_session
    if FeatureFlags.enabled?(:self_employed, session_data)
      attributes.except!("employment_status")
    else
      attributes
    end
  end
end
