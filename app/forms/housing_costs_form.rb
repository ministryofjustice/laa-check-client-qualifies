class HousingCostsForm < BaseHousingCostsForm
  ATTRIBUTES = (BaseHousingCostsForm::ATTRIBUTES + %i[housing_payments housing_payments_frequency]).freeze

  attribute :housing_payments, :gbp
  validates :housing_payments,
            numericality: { greater_than_or_equal_to: 0, allow_nil: true },
            presence: true,
            is_a_number: true

  attribute :housing_payments_frequency, :string
  validates :housing_payments_frequency,
            inclusion: { in: OutgoingsForm::VALID_FREQUENCIES, allow_nil: false },
            if: -> { housing_payments.to_i.positive? }

  def housing_payment_frequencies
    valid_frequencies = level_of_help == "controlled" ? OutgoingsForm::VALID_FREQUENCIES - %w[total] : OutgoingsForm::VALID_FREQUENCIES
    valid_frequencies.map { [_1, I18n.t("question_flow.outgoings.frequencies.#{_1}")] }
  end

private

  def total_annual_housing_costs
    return 0 if housing_payments_frequency.blank?

    housing_payments * annual_multiplier(housing_payments_frequency)
  end
end
