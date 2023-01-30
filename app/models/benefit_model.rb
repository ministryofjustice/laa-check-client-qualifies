class BenefitModel
  include ActiveModel::Model
  include ActiveModel::Attributes
  include SessionPersistable

  FREQUENCY_OPTIONS = %w[every_week every_two_weeks every_four_weeks monthly].freeze

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

  def benefit_list
    @benefit_list ||= CfeConnection.connection.state_benefit_types
  end
end
