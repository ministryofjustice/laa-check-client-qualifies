class IneligibleGrossIncomeForm
  include ActiveModel::Model
  include ActiveModel::Attributes
  include SessionPersistable

  SELECTION = :early_eligibility_selection.to_s

  ATTRIBUTES = [:early_eligibility_selection].freeze
  VALID_OPTIONS = { gross: "gross", continue: "continue_check" }.freeze

  attribute :early_eligibility_selection
  validates :early_eligibility_selection, inclusion: { in: VALID_OPTIONS.values, allow_nil: true }
end
