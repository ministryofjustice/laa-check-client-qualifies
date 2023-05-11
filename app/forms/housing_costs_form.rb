class HousingCostsForm
  include ActiveModel::Model
  include ActiveModel::Attributes
  include SessionPersistable
  include NumberValidatable

  ATTRIBUTES = %i[housing_payments housing_payments_frequency housing_benefit_value housing_benefit_frequency].freeze
  HOUSING_PAYMENT_FREQUENCIES = %w[every_week every_two_weeks every_four_weeks monthly total].freeze

  attribute :housing_payments, :gbp
  validates :housing_payments, numericality: { greater_than: 0, allow_nil: true }, presence: true

  attribute :housing_payments_frequency, :gbp
  validates :housing_payments_frequency, inclusion: { in: HOUSING_PAYMENT_FREQUENCIES, allow_nil: false }

  attribute :housing_benefit_value, :gbp
  validates :housing_benefit_value, numericality: { greater_than: 0, allow_nil: true }, presence: true

  attribute :housing_benefit_frequency, :string
  validates :housing_benefit_frequency, inclusion: { in: BenefitModel::FREQUENCY_OPTIONS, allow_nil: false }

  delegate :level_of_help, to: :check

  def frequencies
    BenefitModel::FREQUENCY_OPTIONS.map { [_1, I18n.t("estimate_flow.benefits.frequencies.#{_1}")] }
  end

  def housing_payment_frequencies
    valid_frequencies = level_of_help == "controlled" ? HOUSING_PAYMENT_FREQUENCIES - %w[total] : HOUSING_PAYMENT_FREQUENCIES
    valid_frequencies.map { [_1, I18n.t("estimate_flow.outgoings.frequencies.#{_1}")] }
    # need to add the right translation path
  end

  def owns_home_outright?
  end

  def owns_home_with_mortgage?
  end

  def rents_home?
  end
end
