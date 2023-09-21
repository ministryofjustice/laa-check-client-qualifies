class ImmigrationOrAsylumTypeUpperTribunalForm
  include ActiveModel::Model
  include ActiveModel::Attributes
  include SessionPersistable

  TYPES = %w[immigration_upper asylum_upper none].freeze

  ATTRIBUTES = %i[immigration_or_asylum_type_upper_tribunal].freeze

  attribute :immigration_or_asylum_type_upper_tribunal
  validates :immigration_or_asylum_type_upper_tribunal, presence: true, inclusion: { in: TYPES, allow_nil: true }
end
