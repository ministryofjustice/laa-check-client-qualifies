class DependantDetailsForm
  include ActiveModel::Model
  include ActiveModel::Attributes
  include SessionPersistable
  include NumberValidatable

  FORM_ATTRIBUTES = {
    child_dependants: :child_dependants_count,
    adult_dependants: :adult_dependants_count,
  }.freeze

  ATTRIBUTES = FORM_ATTRIBUTES.map { |k, v| [k, v] }.flatten.freeze

  FORM_ATTRIBUTES.each do |boolean_field, integer_field|
    attribute boolean_field, :boolean
    validates boolean_field, inclusion: { in: [true, false] }
    attribute integer_field, :fully_validatable_integer
    validates integer_field, presence: true,
                             numericality: { greater_than: 0, only_integer: true },
                             if: ->(m) { m.public_send(boolean_field) }
  end
end
