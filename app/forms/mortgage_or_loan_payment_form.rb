class MortgageOrLoanPaymentForm
  include ActiveModel::Model
  include ActiveModel::Attributes
  include SessionPersistable
  include NumberValidatable

  ATTRIBUTES = %i[housing_loan_payments housing_payments_loan_frequency].freeze

  delegate :level_of_help, :partner, to: :check

  attribute :housing_loan_payments, :gbp
  validates :housing_loan_payments, numericality: { greater_than_or_equal_to: 0, allow_nil: true }, presence: true

  attribute :housing_payments_loan_frequency, :string
  validates :housing_payments_loan_frequency,
            presence: true,
            inclusion: { in: OutgoingsForm::VALID_FREQUENCIES, allow_nil: false },
            if: -> { housing_loan_payments.to_i.positive? }

  def housing_payment_frequencies
    valid_frequencies = level_of_help == "controlled" ? OutgoingsForm::VALID_FREQUENCIES - %w[total] : OutgoingsForm::VALID_FREQUENCIES
    valid_frequencies.map { [_1, I18n.t("question_flow.outgoings.frequencies.#{_1}")] }
  end
end
