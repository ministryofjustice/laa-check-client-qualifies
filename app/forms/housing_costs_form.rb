class HousingCostsForm
  include ActiveModel::Model
  include ActiveModel::Attributes
  include SessionPersistable
  include NumberValidatable

  ATTRIBUTES = %i[housing_payments housing_payments_frequency housing_benefit_value housing_benefit_frequency].freeze

  attribute :housing_payments, :gbp
  validates :housing_payments, numericality: { greater_than_or_equal_to: 0, allow_nil: true }, presence: true

  attribute :housing_payments_frequency, :string
  validates :housing_payments_frequency,
            presence: true,
            inclusion: { in: OutgoingsForm::VALID_FREQUENCIES, allow_nil: false },
            if: -> { housing_payments.to_i.positive? }

  attribute :housing_benefit_value, :gbp
  validates :housing_benefit_value, numericality: { greater_than_or_equal_to: 0, allow_nil: true }, presence: true

  attribute :housing_benefit_frequency, :string
  validates :housing_benefit_frequency,
            presence: true,
            inclusion: { in: BenefitModel::FREQUENCY_OPTIONS, allow_nil: false },
            if: -> { housing_benefit_value.to_i.positive? }

  validate :housing_benefit_does_not_exceed_costs

  delegate :level_of_help, :partner, to: :check

  def frequencies
    BenefitModel::FREQUENCY_OPTIONS.map { [_1, I18n.t("estimate_flow.benefits.frequencies.#{_1}")] }
  end

  def housing_payment_frequencies
    valid_frequencies = level_of_help == "controlled" ? OutgoingsForm::VALID_FREQUENCIES - %w[total] : OutgoingsForm::VALID_FREQUENCIES
    valid_frequencies.map { [_1, I18n.t("estimate_flow.outgoings.frequencies.#{_1}")] }
  end

private

  def housing_benefit_does_not_exceed_costs
    return unless errors.none? &&
      housing_payments.to_i.positive? &&
      housing_benefit_value.to_i.positive? &&
      housing_payments_frequency.present? &&
      housing_benefit_frequency.present?

    annual_housing_payment_value = housing_payments * annual_multiplier(housing_payments_frequency)
    annual_housing_benefit_value = housing_benefit_value * annual_multiplier(housing_benefit_frequency)
    return if annual_housing_payment_value >= annual_housing_benefit_value

    errors.add(:housing_benefit_value, :exceeds_costs)
  end

  def annual_multiplier(frequency)
    case frequency
    when "every_week"
      52
    when "every_two_weeks"
      26
    when "every_four_weeks"
      13
    when "monthly"
      12
    else # The only other value that could be called is "total", meaning total in last 3 months
      4
    end
  end
end
