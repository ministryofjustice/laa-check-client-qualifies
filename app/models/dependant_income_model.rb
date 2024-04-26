class DependantIncomeModel
  include ActiveModel::Model
  include ActiveModel::Attributes
  include SessionPersistable

  include MoneyHelper
  extend MoneyHelper

  ATTRIBUTES = %i[amount frequency].freeze

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

    monthly_upper_limit = self.class.dependant_monthly_upper_limit

    if self.class.dependant_income_upper_limits[frequency] <= amount
      errors.add(:amount, error_message, limit: format_money(monthly_upper_limit))
    end
  end

  class << self
    def dependant_monthly_upper_limit
      361.70
    end

    def error_message_content(key, position_tag)
      I18n.t(key,
             limit: format_money(dependant_monthly_upper_limit),
             position: position_tag)
    end

    def dependant_income_upper_limits
      weekly_limit = dependant_monthly_upper_limit * 12 / 365 * 7
      {
        "every_week" => weekly_limit.round(2),
        "every_two_weeks" => (weekly_limit * 2).round(2),
        "every_four_weeks" => (weekly_limit * 4).round(2),
        "monthly" => dependant_monthly_upper_limit,
        "three_months" => (dependant_monthly_upper_limit * 3).round(2),
      }
    end
  end
end
