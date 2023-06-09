class ImmigrationOrAsylumTypeForm
  include ActiveModel::Model
  include ActiveModel::Attributes
  include SessionPersistable

  TYPES = %w[immigration_clr immigration_legal_help asylum].freeze

  ATTRIBUTES = %i[immigration_or_asylum_type].freeze

  attribute :immigration_or_asylum_type
  validates :immigration_or_asylum_type, presence: true, inclusion: { in: TYPES, allow_nil: true }
end
