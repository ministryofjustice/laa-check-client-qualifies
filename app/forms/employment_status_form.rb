class EmploymentStatusForm
  include ActiveModel::Model
  include ActiveModel::Attributes
  include SessionPersistable

  EMPLOYED_STATUSES = %i[in_work].freeze
  EMPLOYMENT_STATUSES = { in_work: "in_work", unemployed: "unemployed" }.freeze

  ATTRIBUTES = %i[employment_status].freeze

  attribute :employment_status, :string
  validates :employment_status,
            inclusion: { in: EMPLOYMENT_STATUSES.map { |_k, v| v.to_s }, allow_nil: false }
end
