class DependantIncomeModel
  include ActiveModel::Model
  include ActiveModel::Attributes
  include SessionPersistable

  ATTRIBUTES = %i[amount frequency].freeze

  attribute :frequency, :string
  validates :frequency, inclusion: { in: IncomeModel::FREQUENCY_OPTIONS, allow_nil: false }

  attribute :amount, :gbp
  validates :amount, presence: true, numericality: { greater_than: 0, allow_nil: true }, is_a_number: true

  def frequency_options
    IncomeModel.income_frequency_options(skip_year: true)
  end
end
