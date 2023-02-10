class AsylumSupportForm
  include ActiveModel::Model
  include ActiveModel::Attributes
  include SessionPersistable

  ATTRIBUTES = %i[asylum_support].freeze

  attribute :asylum_support, :boolean
  validates :asylum_support, inclusion: { in: [true, false], allow_nil: false }
end
