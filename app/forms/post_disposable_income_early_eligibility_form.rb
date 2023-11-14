class PostDisposableIncomeEarlyEligibilityForm
  include ActiveModel::Model
  include ActiveModel::Attributes
  include SessionPersistable

  ATTRIBUTES = %w[disposable_income_skip_to_check_answers].freeze

  attribute :disposable_income_skip_to_check_answers, :boolean
  validates :disposable_income_skip_to_check_answers, inclusion: { in: [true, false] }
end
