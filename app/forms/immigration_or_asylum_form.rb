class ImmigrationOrAsylumForm
  include ActiveModel::Model
  include ActiveModel::Attributes
  include SessionPersistable

  ATTRIBUTES = [:immigration_or_asylum].freeze

  attribute :immigration_or_asylum, :boolean
  validates :immigration_or_asylum, inclusion: { in: [true, false] }
end
