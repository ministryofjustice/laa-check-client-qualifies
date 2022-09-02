class PropertyForm
  include ActiveModel::Model
  include ActiveModel::Attributes

  OWNED_OPTIONS = [:outright, :with_mortgage, :none].freeze

  attribute :property_owned, :string
  validates :property_owned, inclusion: {in: OWNED_OPTIONS.map(&:to_s), allow_nil: false}

  def owned?
    [:with_mortgage, :outright].include? property_owned
  end
end
