class SatisfactionFeedback < ApplicationRecord
  OUTCOMES = %w[eligible eligible_contribution_required inelible].freeze
  attribute :satisfied, :string
  attribute :level_of_help, :string
  attribute :outcome, :string

  validates :satisfied, inclusion: { in: %w[yes no] }
end
