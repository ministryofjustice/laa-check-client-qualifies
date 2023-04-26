class ApplicantForm
  include ActiveModel::Model
  include ActiveModel::Attributes
  include SessionPersistable

  PROCEEDING_TYPES = { domestic_abuse: "DA001", other: "SE003" }.freeze
  EMPLOYED_STATUSES = %i[in_work receiving_statutory_pay].freeze
  EMPLOYMENT_STATUSES = (EMPLOYED_STATUSES + %i[unemployed]).freeze

  STRING_ATTRIBUTES = %i[employment_status].freeze
  BOOLEAN_ATTRIBUTES = %i[over_60 partner passporting].freeze

  ATTRIBUTES = (BOOLEAN_ATTRIBUTES + STRING_ATTRIBUTES).freeze

  attribute :over_60, :boolean
  validates :over_60, inclusion: { in: [true, false] }

  attribute :employment_status, :string
  validates :employment_status,
            inclusion: { in: EMPLOYMENT_STATUSES.map(&:to_s), allow_nil: false }

  attribute :partner, :boolean
  validates :partner, inclusion: { in: [true, false] }

  attribute :passporting, :boolean
  validates :passporting, inclusion: { in: [true, false] }
end
