class BenefitsForm
  include ActiveModel::Model
  include ActiveModel::Attributes
  include SessionPersistable

  ATTRIBUTES = [:receives_benefits].freeze

  attribute :receives_benefits, :boolean
  validates :receives_benefits, inclusion: { in: [true, false] }
end
