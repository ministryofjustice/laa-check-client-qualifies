class ControlledLegalRepresentationForm
  include ActiveModel::Model
  include ActiveModel::Attributes
  include SessionPersistable

  ATTRIBUTES = [:controlled_legal_representation].freeze

  attribute :controlled_legal_representation, :boolean
  validates :controlled_legal_representation, inclusion: { in: [true, false], allow_nil: false }
end
