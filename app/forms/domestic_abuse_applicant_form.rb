class DomesticAbuseApplicantForm
  include ActiveModel::Model
  include ActiveModel::Attributes
  include SessionPersistable

  ATTRIBUTES = %i[domestic_abuse_applicant].freeze

  attribute :domestic_abuse_applicant, :boolean
  validates :domestic_abuse_applicant, inclusion: { in: [true, false], allow_nil: false }
end
