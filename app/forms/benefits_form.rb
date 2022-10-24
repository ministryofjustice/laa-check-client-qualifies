class BenefitsForm
  include ActiveModel::Model
  include ActiveModel::Attributes

  ATTRIBUTES = [:add_benefit].freeze

  attribute :add_benefit, :boolean
  validates :add_benefit, inclusion: { in: [true, false] }

  attr_accessor :benefits
end
