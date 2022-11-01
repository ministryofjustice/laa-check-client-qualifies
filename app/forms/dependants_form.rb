class DependantsForm
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :dependants, :boolean
  validates :dependants, inclusion: { in: [true, false], allow_nil: false }
end
