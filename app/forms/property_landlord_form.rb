class PropertyLandlordForm
  include ActiveModel::Model
  include ActiveModel::Attributes
  include SessionPersistable

  ATTRIBUTES = %i[property_landlord].freeze

  attribute :property_landlord, :boolean
  validates :property_landlord, inclusion: { in: [true, false], allow_nil: false }
end
