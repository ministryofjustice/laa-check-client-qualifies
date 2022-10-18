class BenefitDetailsForm
  include ActiveModel::Model
  include ActiveModel::Attributes

  ATTRIBUTES = %i[benefit_type benefit_amount benefit_frequency index].freeze

  attribute :benefit_type, :string
  validates :benefit_type, presence: true
  attribute :benefit_amount, :decimal
  validates :benefit_amount, presence: true, numericality: { greater_than: 0, allow_nil: true }
  attribute :benefit_frequency, :integer
  validates :benefit_frequency, inclusion: { in: [1, 2, 4], allow_nil: false }

  attribute :index, :integer
end
