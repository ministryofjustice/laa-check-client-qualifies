class SatisfactionFeedback < ApplicationRecord
  attribute :satisfied, :boolean
  attribute :level_of_help, :string
  attribute :outcome, :string
end
