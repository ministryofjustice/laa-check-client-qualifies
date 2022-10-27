class BenefitModel
  include ActiveModel::Model
  include ActiveModel::Attributes

  FREQUENCY_OPTIONS = %w[weekly two_weekly four_weekly].freeze

  attribute :id

  EDITABLE_ATTRIBUTES = %i[benefit_type benefit_amount benefit_frequency return_to_check_answers].freeze
  BENEFITS_ATTRIBUTES = (EDITABLE_ATTRIBUTES + %i[id]).freeze

  attribute :benefit_type, :string
  validates :benefit_type, presence: true
  attribute :benefit_amount, :gbp
  validates :benefit_amount, presence: true, numericality: { greater_than: 0, allow_nil: true }

  attribute :benefit_frequency, :string
  validates :benefit_frequency, inclusion: { in: FREQUENCY_OPTIONS, allow_nil: false }

  attribute :return_to_check_answers, :boolean

  def benefit_options
    FREQUENCY_OPTIONS.map { [_1, I18n.t("estimate_flow.benefits.frequencies.#{_1}")] }
  end
end
