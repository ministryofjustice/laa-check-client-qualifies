class IntroForm
  include ActiveModel::Model
  include ActiveModel::Attributes

  INTRO_YES_NO_ATTRIBUTES = %i[passporting over_60 dependants partner].freeze
  INTRO_ATTRIBUTES = (INTRO_YES_NO_ATTRIBUTES + [:employed]).freeze

  INTRO_YES_NO_ATTRIBUTES.each do |attr|
    attribute attr, :boolean
    validates attr, inclusion: { in: [true, false] }
  end

  attribute :employed, :boolean
  validates :employed, inclusion: { in: [true, false] }
end
