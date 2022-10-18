class BenefitYesnoForm
  include ActiveModel::Model
  include ActiveModel::Attributes

  ATTRIBUTES = [:has_benefits].freeze

  attribute :has_benefits, :boolean
  validates :has_benefits, inclusion: { in: [true, false] }
end
