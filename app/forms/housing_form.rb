class HousingForm
  include ActiveModel::Model
  include ActiveModel::Attributes
  include SessionPersistable

  VALID_FREQUENCIES = %w[every_week every_two_weeks every_four_weeks monthly total].freeze

  ATTRIBUTES = %i[housing_payments_value
                  housing_payments_frequency
                  receives_housing_benefit
                  housing_benefit_value
                  housing_benefit_frequency].freeze

  attribute :housing_payments_value, :gbp
  attribute :housing_payments_frequency, :string
  attribute :receives_housing_benefit, :boolean
  attribute :housing_benefit_value, :gbp
  attribute :housing_benefit_frequency, :string

  validates :housing_payments_value, presence: true, numericality: { greater_than_or_equal_to: 0, allow_nil: true }
  validates :housing_payments_frequency, presence: true,
                                         inclusion: { in: VALID_FREQUENCIES, allow_nil: false },
                                         if: -> { housing_payments_value.to_i.positive? }

  validates :receives_housing_benefit, inclusion: { in: [true, false], allow_nil: false }

  validates :housing_benefit_value, presence: true,
                                    numericality: { greater_than: 0, allow_nil: true },
                                    if: -> { receives_housing_benefit }
  validates :housing_benefit_frequency, presence: true,
                                        inclusion: { in: (VALID_FREQUENCIES - %i[total]), allow_nil: false },
                                        if: -> { receives_housing_benefit }

  def frequencies(attribute)
    valid_frequencies = attribute == :housing_payments_frequency ? VALID_FREQUENCIES : (VALID_FREQUENCIES - %i[total])
    valid_frequencies.map { [_1, I18n.t("estimate_flow.outgoings.frequencies.#{_1}")] }
  end
end
