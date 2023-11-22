class ClientAgeForm
  include ActiveModel::Model
  include ActiveModel::Attributes
  include SessionPersistable

  UNDER_18 = "under_18".freeze
  OVER_60 = "over_60".freeze
  STANDARD = "standard".freeze

  ATTRIBUTES = %i[client_age].freeze

  OPTIONS = [UNDER_18, STANDARD, OVER_60].freeze

  attribute :client_age, :string
  validates :client_age, inclusion: { in: OPTIONS, allow_nil: false }
end
