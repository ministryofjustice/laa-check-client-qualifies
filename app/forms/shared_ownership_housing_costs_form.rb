class SharedOwnershipHousingCostsForm < BaseHousingCostsForm
  ATTRIBUTES = (BaseHousingCostsForm::ATTRIBUTES + %i[shared_ownership_mortgage mortgage_frequency rent rent_frequency]).freeze

  attribute :shared_ownership_mortgage, :gbp
  validates :shared_ownership_mortgage,
            numericality: { greater_than_or_equal_to: 0, allow_nil: false },
            is_a_number: true

  attribute :mortgage_frequency, :string
  validates :mortgage_frequency,
            inclusion: { in: OutgoingsForm::VALID_FREQUENCIES, allow_nil: false },
            if: -> { shared_ownership_mortgage.to_i.positive? }

  attribute :rent, :gbp
  validates :rent,
            numericality: { greater_than_or_equal_to: 0, allow_nil: false },
            is_a_number: true

  attribute :rent_frequency, :string
  validates :rent_frequency,
            inclusion: { in: OutgoingsForm::VALID_FREQUENCIES, allow_nil: false },
            if: -> { rent.to_i.positive? }

  def housing_payment_frequencies
    OutgoingsForm::VALID_FREQUENCIES.map { [_1, I18n.t("question_flow.outgoings.frequencies.#{_1}")] }
  end

private

  def total_annual_housing_costs
    total = 0

    # Only add mortgage costs if we have a frequency (amount can be zero)
    if mortgage_frequency.present?
      total += shared_ownership_mortgage * annual_multiplier(mortgage_frequency)
    end

    # Only add rent costs if we have a frequency (amount can be zero)
    if rent_frequency.present?
      total += rent * annual_multiplier(rent_frequency)
    end

    total
  end
end
