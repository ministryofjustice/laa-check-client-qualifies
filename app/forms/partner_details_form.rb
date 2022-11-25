class PartnerDetailsForm
  include ActiveModel::Model
  include ActiveModel::Attributes
  include SessionPersistableForPartner

  ATTRIBUTES = %i[over_60 employed dependants].freeze

  ATTRIBUTES.each do |attr|
    attribute attr, :boolean
    validates attr, inclusion: { in: [true, false] }
  end
end
