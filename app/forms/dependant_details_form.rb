class DependantDetailsForm
  include ActiveModel::Model
  include ActiveModel::Attributes
  include SessionPersistable

  ATTRIBUTES = %i[adult_dependants child_dependants].freeze

  ATTRIBUTES.each do |attr|
    attribute attr, :integer
    validates attr, presence: true
  end
end
