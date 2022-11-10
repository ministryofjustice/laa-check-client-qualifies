class PartnerForm
  include ActiveModel::Model
  include ActiveModel::Attributes

  ATTRIBUTES = %i[partner].freeze

  ATTRIBUTES.each do |attr|
    attribute attr, :boolean
    validates attr, inclusion: { in: [true, false] }
  end
end
