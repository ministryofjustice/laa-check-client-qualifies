class RegularIncomeForm
  include ActiveModel::Model
  include ActiveModel::Attributes
  include SessionPersistable

  ATTRIBUTES = %i[regular_income].freeze

  attribute :regular_income, :boolean
  validates :regular_income, inclusion: { in: [true, false], allow_nil: false }
end
