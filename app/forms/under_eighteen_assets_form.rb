class UnderEighteenAssetsForm
  include ActiveModel::Model
  include ActiveModel::Attributes
  include SessionPersistable

  ATTRIBUTES = %i[under_eighteen_assets].freeze

  attribute :under_eighteen_assets, :boolean
  validates :under_eighteen_assets, inclusion: { in: [true, false], allow_nil: false }
end
