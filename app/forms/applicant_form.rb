class ApplicantForm
  include ActiveModel::Model
  include ActiveModel::Attributes

  PERMANENT_ATTRIBUTES = %i[passporting over_60 employed].freeze
  CONTINGENT_ATTRIBUTES = %i[partner_over_60 partner_employed].freeze

  ATTRIBUTES = PERMANENT_ATTRIBUTES + CONTINGENT_ATTRIBUTES.freeze

  attr_accessor :partner

  PERMANENT_ATTRIBUTES.each do |attr|
    attribute attr, :boolean
    validates attr, inclusion: { in: [true, false] }
  end

  CONTINGENT_ATTRIBUTES.each do |attr|
    attribute attr, :boolean
    validates attr, inclusion: { in: [true, false] }, if: -> { partner }
  end
end
