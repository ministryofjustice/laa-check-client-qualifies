class ApplicantForm
  include ActiveModel::Model
  include ActiveModel::Attributes
  include SessionPersistable

  ATTRIBUTES = %i[partner passporting].freeze

  ATTRIBUTES.each do |attr|
    attribute attr, :boolean
    validates attr, inclusion: { in: [true, false] }
  end
end
