class PartnerDetailsForm
  include ActiveModel::Model
  include ActiveModel::Attributes
  include SessionPersistableForPartner

  delegate :passporting, to: :check
  delegate :session_data, to: :check

  ATTRIBUTES = %i[over_60 employment_status].freeze

  attribute :over_60, :boolean
  validates :over_60, inclusion: { in: [true, false] }

  attribute :employment_status, :string
  validates :employment_status,
            inclusion: { in: ApplicantForm::EMPLOYMENT_STATUSES.map(&:to_s), allow_nil: false },
            if: -> { !passporting && !FeatureFlags.enabled?(:self_employed, session_data) }
end
