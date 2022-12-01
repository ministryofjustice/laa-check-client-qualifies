class HousingBenefitForm
  include ActiveModel::Model
  include ActiveModel::Attributes
  include SessionPersistable

  ATTRIBUTES = [:housing_benefit].freeze

  attribute :housing_benefit, :boolean
  validates :housing_benefit, inclusion: { in: [true, false], allow_nil: false }
end
