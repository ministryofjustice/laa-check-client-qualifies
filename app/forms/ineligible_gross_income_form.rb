class IneligibleGrossIncomeForm
  include ActiveModel::Model
  include ActiveModel::Attributes
  include SessionPersistable

  ATTRIBUTES = [:check_answers].freeze
  attribute :check_answers
end
