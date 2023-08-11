class DependantIncomeForm
  include ActiveModel::Model
  include ActiveModel::Attributes
  include SessionPersistable

  ATTRIBUTES = %i[dependants_get_income].freeze

  attribute :dependants_get_income, :boolean
  validates :dependants_get_income, inclusion: { in: [true, false], allow_nil: false }
end
