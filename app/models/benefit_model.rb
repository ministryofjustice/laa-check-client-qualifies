class BenefitModel
  include ActiveModel::Model
  include ActiveModel::Attributes
  include SessionPersistable

  FREQUENCY_OPTIONS = %w[every_week every_two_weeks every_four_weeks monthly].freeze

  PASSPORTED_BENEFITS = %w[
    age_related_payment
    universal_credit
    income_support
    jobseekers_allowance
    employment_support_allowance
    pension_credit
  ].freeze

  attribute :id

  EDITABLE_ATTRIBUTES = %i[benefit_type benefit_amount benefit_frequency].freeze
  ATTRIBUTES = (EDITABLE_ATTRIBUTES + %i[id]).freeze

  attribute :benefit_type, :string
  validates :benefit_type, presence: true
  attribute :benefit_amount, :gbp
  validates :benefit_amount, presence: true, numericality: { greater_than: 0, allow_nil: true }

  attribute :benefit_frequency, :string
  validates :benefit_frequency, inclusion: { in: FREQUENCY_OPTIONS, allow_nil: false }

  def benefit_options
    FREQUENCY_OPTIONS.map { [_1, I18n.t("estimate_flow.benefits.frequencies.#{_1}")] }
  end

  def cfe_benefit_list
    CfeConnection.connection.state_benefit_types
  end

  def benefit_list
    display_list = cfe_benefit_list.reject { _1["exclude_from_gross_income"] || _1["label"].in?(PASSPORTED_BENEFITS) }
    display_list.map { _1["name"] }.uniq
  end
end
