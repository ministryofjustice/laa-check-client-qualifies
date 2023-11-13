class PostGrossIncomeEarlyEligibilityForm
  include ActiveModel::Model
  include ActiveModel::Attributes
  include SessionPersistable

  ATTRIBUTES = %w[gross_income_early_eligibility].freeze

  attribute :skip_to_check_answers, :boolean
  validates :skip_to_check_answers, inclusion: { in: [true, false] }
end
