class PostGrossIncomeEarlyEligibilityForm
  include ActiveModel::Model
  include ActiveModel::Attributes
  include SessionPersistable

  ATTRIBUTES = %w[gross_income_skip_to_check_answers].freeze

  attribute :gross_income_skip_to_check_answers, :boolean
  validates :gross_income_skip_to_check_answers, inclusion: { in: [true, false] }
end
