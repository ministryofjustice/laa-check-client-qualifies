class SharedOwnershipHousingCostsForm < BaseHousingCostsForm
  ATTRIBUTES = (BaseHousingCostsForm::ATTRIBUTES + %i[shared_ownership_mortgage rent combined_frequency]).freeze

  attribute :rent, :gbp
  validates :rent,
            numericality: { greater_than_or_equal_to: 0, allow_nil: false },
            is_a_number: true

  attribute :shared_ownership_mortgage, :gbp
  validates :shared_ownership_mortgage,
            numericality: { greater_than_or_equal_to: 0, allow_nil: false },
            is_a_number: true

  attribute :combined_frequency, :string
  validates :combined_frequency,
            inclusion: { in: OutgoingsForm::VALID_FREQUENCIES, allow_nil: false },
            if: -> { combined_rent_and_mortgage.to_i.positive? }

  def housing_payment_frequencies
    OutgoingsForm::VALID_FREQUENCIES.map { [_1, I18n.t("question_flow.outgoings.frequencies.#{_1}")] }
  end

  def combined_rent_and_mortgage
    (shared_ownership_mortgage.to_f + rent.to_f).round(2)
  end

private

  def total_annual_housing_costs
    return 0 if combined_frequency.blank?

    combined_rent_and_mortgage * annual_multiplier(combined_frequency)
  end
end
