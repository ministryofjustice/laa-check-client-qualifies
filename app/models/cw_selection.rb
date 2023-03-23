class CwSelection
  include ActiveModel::Model
  include ActiveModel::Attributes

  OPTIONS = %i[cw1 cw2 cw1_and_2 cw5 civ_means_7].freeze
  attribute :form_type, :string
  validates :form_type, presence: true, inclusion: { in: OPTIONS.map(&:to_s), allow_nil: true }
end
