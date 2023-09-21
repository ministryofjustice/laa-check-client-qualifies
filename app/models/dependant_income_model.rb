class DependantIncomeModel
  include ActiveModel::Model
  include ActiveModel::Attributes
  include SessionPersistable

  ATTRIBUTES = %i[amount frequency].freeze
  DEPENDANT_INCOME_UPPER_LIMITS = {
    "every_week" => 78.20,
    "every_two_weeks" => 156.40,
    "every_four_weeks" => 312.80,
    "monthly" => 338.90,
    "three_months" => 1016.70,
  }.freeze

  attribute :frequency, :string
  validates :frequency, inclusion: { in: IncomeModel::FREQUENCY_OPTIONS, allow_nil: false }

  attribute :amount, :gbp
  validates :amount, presence: true, numericality: { greater_than: 0, allow_nil: true }, is_a_number: true

  validate :income_too_high

  def frequency_options
    IncomeModel.income_frequency_options(skip_year: true)
  end

  def income_too_high
    return unless errors.none?

    error_message = frequency.include?("monthly") ? :dependant_monthly_income_too_high : :dependant_monthly_equivalent_income_too_high

    if DEPENDANT_INCOME_UPPER_LIMITS[frequency] <= amount
      errors.add(:amount, error_message)
    end
  end
end
