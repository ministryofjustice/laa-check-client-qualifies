class TribunalForm
  include ActiveModel::Model
  include ActiveModel::Attributes
  include SessionPersistable

  ATTRIBUTES = [:upper_tribunal].freeze

  LEVELS_OF_HELP = %w[controlled certificated].freeze

  attribute :upper_tribunal, :boolean
  validates :upper_tribunal, inclusion: { in: [true, false], allow_nil: false }
end
