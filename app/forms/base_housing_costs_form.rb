class BaseHousingCostsForm
  include ActiveModel::Model
  include ActiveModel::Attributes
  include SessionPersistable

  ATTRIBUTES = %i[
    housing_benefit_value
    housing_benefit_frequency
    housing_benefit_relevant
  ].freeze

  attribute :housing_benefit_relevant, :boolean
  validates :housing_benefit_relevant, inclusion: { in: [true, false], allow_nil: false }

  attribute :housing_benefit_value, :gbp
  validates :housing_benefit_value,
            numericality: { greater_than: 0 },
            presence: true,
            is_a_number: true,
            if: -> { housing_benefit_relevant }

  attribute :housing_benefit_frequency, :string
  validates :housing_benefit_frequency,
            inclusion: { in: BenefitModel::FREQUENCY_OPTIONS, allow_nil: false },
            if: -> { housing_benefit_relevant }

  validate :housing_benefit_does_not_exceed_costs

  delegate :level_of_help, :partner, to: :check

  def frequencies
    BenefitModel::FREQUENCY_OPTIONS.map { [_1, I18n.t("question_flow.benefits.frequencies.#{_1}")] }
  end

private

  def housing_benefit_does_not_exceed_costs
    return unless housing_benefit_relevant &&
      housing_benefit_value.is_a?(Numeric) &&
      housing_benefit_value.positive? &&
      housing_benefit_frequency.present?

    total_costs = total_annual_housing_costs

    # Return early if total_costs is not a numeric type or is zero
    return unless total_costs.is_a?(Numeric) && total_costs.nonzero?

    # Ensure housing_benefit_value is numeric and frequency is valid
    # :nocov:
    return unless housing_benefit_value.is_a?(Numeric) && annual_multiplier(housing_benefit_frequency)
    # :nocov:

    annual_housing_payment_value = total_costs
    annual_housing_benefit_value = housing_benefit_value * annual_multiplier(housing_benefit_frequency)

    return if annual_housing_payment_value >= annual_housing_benefit_value

    errors.add(:housing_benefit_value, :exceeds_costs)
  end

  def annual_multiplier(frequency)
    case frequency
    when "every_week" then 52
    when "every_two_weeks" then 26
    when "every_four_weeks" then 13
    when "monthly" then 12
    else 4 # The only other value that could be called is "total", meaning total in last 3 months
    end
  end

  def total_annual_housing_costs
    # :nocov:
    raise NotImplementedError, "Subclasses must implement the total_annual_housing_costs method"
    # :nocov:
  end
end
