class PartnerDetailsForm
  include ActiveModel::Model
  include ActiveModel::Attributes
  include SessionPersistableForPartner

  ATTRIBUTES = %i[over_60].freeze

  attribute :over_60, :boolean
  validates :over_60, inclusion: { in: [true, false] }
end
