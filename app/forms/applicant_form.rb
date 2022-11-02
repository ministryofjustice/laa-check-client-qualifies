class ApplicantForm
  include ActiveModel::Model
  include ActiveModel::Attributes

  INTRO_ATTRIBUTES = %i[passporting over_60 partner employed].freeze

  INTRO_ATTRIBUTES.each do |attr|
    attribute attr, :boolean

    # TODO: Re-add validation for partner question when we implement partner functionality
    validates(attr, inclusion: { in: [true, false] }) unless attr == :partner
  end
end
