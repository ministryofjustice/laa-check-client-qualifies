class IneligibleGrossIncomeForm
  include ActiveModel::Model
  include ActiveModel::Attributes
  include SessionPersistable

  ATTRIBUTES = [:check_answers].freeze
  attribute :check_answers
  validates :check_answers, inclusion: { in: %w[gross return], allow_nil: true }
end
