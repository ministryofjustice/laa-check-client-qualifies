class IntroForm
  include ActiveModel::Model
  include ActiveModel::Attributes

  INTRO_BOOLEAN_ATTRIBUTES = %i[passporting over_60 dependants partner employed].freeze
  INTRO_ATTRIBUTES = (INTRO_BOOLEAN_ATTRIBUTES + [:dependant_count]).freeze

  INTRO_BOOLEAN_ATTRIBUTES.each do |attr|
    attribute attr, :boolean
    validates attr, inclusion: { in: [true, false] }
  end

  attribute :dependant_count, :integer
  validates :dependant_count, numericality: { greater_than: 0, only_integer: true, allow_nil: true }, presence: true, if: -> { dependants }
end
