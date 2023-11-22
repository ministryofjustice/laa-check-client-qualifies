class AggregatedMeansForm
  include ActiveModel::Model
  include ActiveModel::Attributes
  include SessionPersistable

  ATTRIBUTES = %i[aggregated_means].freeze

  attribute :aggregated_means, :boolean
  validates :aggregated_means, inclusion: { in: [true, false], allow_nil: false }
end
