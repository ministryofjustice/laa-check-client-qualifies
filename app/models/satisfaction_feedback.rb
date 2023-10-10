class SatisfactionFeedback < ApplicationRecord
  attribute :satisfied, :string
  attribute :level_of_help, :string
  attribute :outcome, :string

  validates :satisfied, presence: true, inclusion: { in: %w[yes no] }
  validates :level_of_help, presence: true
  validates :outcome, presence: true
end
