class DependantIncomeModel
  include ActiveModel::Model
  include ActiveModel::Attributes
  include SessionPersistable
  include NumberValidatable

  ATTRIBUTES = %i[amount frequency].freeze

  attribute :amount, :gbp
  validates :amount, presence: true, numericality: { greater_than: 0, allow_nil: true }

  attribute :frequency, :string
  validates :frequency, inclusion: { in: OtherIncomeForm::VALID_FREQUENCIES, allow_nil: false }

  def frequency_options
    IncomeModel.income_frequency_options(skip_year: true)
  end
end
