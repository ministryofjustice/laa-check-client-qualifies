class ClientAgeForm
  include ActiveModel::Model
  include ActiveModel::Attributes
  include SessionPersistable

  ATTRIBUTES = %i[client_age].freeze

  OPTIONS = %i[under_18 standard over_60].freeze

  attribute :client_age, :string
  validates :client_age, inclusion: { in: OPTIONS.map(&:to_s), allow_nil: false }
end
