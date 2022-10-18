class BenefitMoreForm
  include ActiveModel::Model
  include ActiveModel::Attributes

  FORM_ATTRIBUTES = [:more_benefits].freeze
  BENEFITS_ATTRIBUTES = [:benefits].freeze
  ATTRIBUTES = (FORM_ATTRIBUTES + BENEFITS_ATTRIBUTES).freeze

  attribute :benefits, array: true, default: []

  attribute :more_benefits, :boolean
  validates :more_benefits, inclusion: { in: [true, false] }
end
