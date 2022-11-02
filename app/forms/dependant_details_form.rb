class DependantDetailsForm
  include ActiveModel::Model
  include ActiveModel::Attributes

  DEPENDANT_ATTRIBUTES = %i[adult_dependants child_dependants].freeze

  DEPENDANT_ATTRIBUTES.each do |attr|
    attribute attr, :integer
    validates attr, presence: true
  end
end
