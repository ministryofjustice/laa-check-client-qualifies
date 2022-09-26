class OutgoingsForm
  include ActiveModel::Model
  include ActiveModel::Attributes

  # list of checkbox values ticked on the form
  attribute :outgoings, array: true, default: []

  # If the 'exclusive' option is picked, then no items are sent
  # otherwise we should get at least 2 (a blank plus at least one selected)
  validates :outgoings, at_least_one_item: true

  OUTGOING_ATTRIBUTES = %i[housing_payments].freeze

  OUTGOING_ATTRIBUTES.each do |attribute|
    attribute attribute, :decimal
    validates attribute,
              numericality: { greater_than: 0, allow_nil: true },
              presence: true,
              if: -> { outgoings.include?(attribute.to_s) }
  end
end
