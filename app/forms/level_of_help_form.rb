class LevelOfHelpForm
  include ActiveModel::Model
  include ActiveModel::Attributes
  include SessionPersistable

  ATTRIBUTES = [:level_of_help].freeze

  LEVELS_OF_HELP = { controlled: "controlled", certificated: "certificated" }.freeze

  attribute :level_of_help
  validates :level_of_help, presence: true, inclusion: { in: LEVELS_OF_HELP.values }
end
