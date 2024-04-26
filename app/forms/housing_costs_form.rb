class HousingCostsForm
  include ActiveModel::Model
  include ActiveModel::Attributes
  include SessionPersistable

  ATTRIBUTES = %i[housing_payments housing_payments_frequency housing_benefit_value housing_benefit_frequency housing_benefit_relevant].freeze

  attribute :housing_payments, :gbp
  validates :housing_payments, numericality: { greater_than_or_equal_to: 0, allow_nil: true }, presence: true, is_a_number: true

  attribute :housing_payments_frequency, :string
  validates :housing_payments_frequency,
            inclusion: { in: OutgoingsForm::VALID_FREQUENCIES, allow_nil: false },
            if: -> { housing_payments.to_i.positive? }

  attribute :housing_benefit_relevant, :boolean
  validates :housing_benefit_relevant,
            inclusion: { in: [true, false], allow_nil: false },
            unless: -> { FeatureFlags.enabled?(:legacy_housing_benefit_without_reveals, check.session_data) }

  attribute :housing_benefit_value, :gbp
  validates :housing_benefit_value,
            numericality: { greater_than: 0 },
            presence: true,
            is_a_number: true,
            if: -> { housing_benefit_relevant && !FeatureFlags.enabled?(:legacy_housing_benefit_without_reveals, check.session_data) }

  validates :housing_benefit_value,
            numericality: { greater_than_or_equal_to: 0, allow_nil: true },
            presence: {  message: :housing_benefit_legacy_presence },
            is_a_number: true,
            if: -> { FeatureFlags.enabled?(:legacy_housing_benefit_without_reveals, check.session_data) }

  attribute :housing_benefit_frequency, :string
  validates :housing_benefit_frequency,
            inclusion: { in: BenefitModel::FREQUENCY_OPTIONS, allow_nil: false },
            if: -> { is_housing_benefit_relevant? }

  validate :housing_benefit_does_not_exceed_costs

  delegate :level_of_help, :partner, to: :check

  def frequencies
    BenefitModel::FREQUENCY_OPTIONS.map { [_1, I18n.t("question_flow.benefits.frequencies.#{_1}")] }
  end

  def housing_payment_frequencies
    valid_frequencies = level_of_help == "controlled" ? OutgoingsForm::VALID_FREQUENCIES - %w[total] : OutgoingsForm::VALID_FREQUENCIES
    valid_frequencies.map { [_1, I18n.t("question_flow.outgoings.frequencies.#{_1}")] }
  end

  # housing_benefit_relevant? could be a method created by rails for a boolean property, so
  # calling this something different to avoid confusion
  def is_housing_benefit_relevant?
    if FeatureFlags.enabled?(:legacy_housing_benefit_without_reveals, check.session_data)
      housing_benefit_value.to_i.positive?
    else
      housing_benefit_relevant
    end
  end

private

  def housing_benefit_does_not_exceed_costs
    return unless errors.none? &&
      is_housing_benefit_relevant? &&
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
