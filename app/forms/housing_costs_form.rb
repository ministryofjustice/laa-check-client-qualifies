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

  delegate :level_of_help, :partner, to: :check

  def frequencies
    BenefitModel::FREQUENCY_OPTIONS.map { [_1, I18n.t("estimate_flow.benefits.frequencies.#{_1}")] }
  end

  def housing_payment_frequencies
    valid_frequencies = level_of_help == "controlled" ? OutgoingsForm::VALID_FREQUENCIES - %w[total] : OutgoingsForm::VALID_FREQUENCIES
    valid_frequencies.map { [_1, I18n.t("estimate_flow.outgoings.frequencies.#{_1}")] }
  end
end
